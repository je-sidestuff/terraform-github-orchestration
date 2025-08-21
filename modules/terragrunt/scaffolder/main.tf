
locals {
  template_scaffolding_paths = {
    for target, data in data.external.module_scaffold_data :
    target => jsondecode(data.result.module_data).default_path_tmpl
  }
  resolved_scaffolding_paths = {
    for target, data in var.input_targets :
    target => 
      templatestring(local.template_scaffolding_paths[target], {
        "subscription" = data.placement.subscription
        "region"       = data.placement.region
        "env"          = data.placement.env
        "name"         = target
      })
  }

  scaffolded_subscriptions = distinct([
    for target, data in var.input_targets : data.placement.subscription
  ])

  base_regions = distinct([
    for target, data in var.input_targets : data.placement.region
  ])
  scaffolded_regions = flatten([
    for subscription in local.scaffolded_subscriptions : [
      for region in local.base_regions : [
        "${subscription}/${region}"
      ]
    ]
  ])

  base_environments = distinct([
    for target, data in var.input_targets : data.placement.env
  ])
  scaffolded_environments = flatten([
    for subscription in local.scaffolded_subscriptions : flatten([
      for region in local.base_regions : [
        for environment in local.base_environments : [
          "${subscription}/${region}/${environment}"
        ]
      ]
    ])
  ])

  input_target_vars = {
    for target, data in var.input_targets :
    target => join(" ",[
      for varname, value in data.vars : "--var=${varname}=${value}"
    ])
  }

  input_target_var_files = {
    for target, data in var.input_targets :
    target => join(" ",[
      for filename in data.var_file_strings : "--var-file=${abspath(path.root)}/${filename}"
    ],[
      for filename in data.var_files : "--var-file=${abspath(path.root)}/${filename}"
    ])
  }

  maybe_backend = ""
  maybe_provider = ""
}

resource "local_file" "root_hcl" {
  content = templatefile("${path.module}/root.hcl.tmpl", {
    "maybe_backend"   = local.maybe_backend
    "maybe_provider"  = local.maybe_provider
    "subscription_id" = var.subscription_id
  })
  filename = "${var.scaffolding_root}/terragrunt/root.hcl"
}

resource "local_file" "common_hcl" {
  content = <<EOF
locals {
  todo = "Put useful stuff here"
}
EOF
  filename = "${var.scaffolding_root}/terragrunt/_envcommon/common.hcl"
}

resource "local_file" "subscription_hcl" {
  for_each = toset(local.scaffolded_subscriptions)

  content = templatefile("${path.module}/subscription.hcl.tmpl", {
    "subscription_id" = var.subscription_id
  })

  filename = "${var.scaffolding_root}/terragrunt/${each.key}/subscription.hcl"
}

resource "local_file" "region_hcl" {
  for_each = toset(local.scaffolded_regions)

  content = file("${path.module}/region.hcl.tmpl") # Templatefile will be needed when we have _globals later
  filename = "${var.scaffolding_root}/terragrunt/${each.key}/region.hcl"
}

resource "local_file" "env_hcl" {
  for_each = toset(local.scaffolded_environments)

  content = file("${path.module}/env.hcl.tmpl") # Templatefile will be needed when we have _globals later
  filename = "${var.scaffolding_root}/terragrunt/${each.key}/env.hcl"
}

data "external" "module_scaffold_data" {
  for_each = var.input_targets

  program = ["bash", "${path.module}/read_module_data.sh"]

  query = {
    repo_full_name = each.value.repo
    ref            = each.value.ref
    path           = each.value.path
  }
}

resource "local_file" "scaffolding_record" {
  for_each = var.input_targets

  filename = "${var.scaffolding_root}/terragrunt/${local.resolved_scaffolding_paths[each.key]}/SCAFFOLDED.md"
  content  = "Scaffolded by je-sidestuff/terraform-github-orchestration/<VERSION>"
}

resource "local_file" "var_file" {
  for_each = var.var_file_strings

  filename = "${path.root}/${each.key}"
  content  = each.value
}

resource "terraform_data" "scaffolding" {
  for_each = var.input_targets

  provisioner "local-exec" {
    command = <<EOT
cd "${var.scaffolding_root}/terragrunt/${local.resolved_scaffolding_paths[each.key]}/"
terragrunt scaffold github.com/${each.value.repo}//${each.value.path}?ref=${each.value.ref} ${local.input_target_vars[each.key]} ${local.input_target_var_files[each.key]}
cd -
EOT
  }

  depends_on = [ local_file.scaffolding_record ]
}

output "module_scaffold_data" {
  value = local.resolved_scaffolding_paths
}

output "locals" {
  value = {
    "scaffolded_subscriptions" = local.scaffolded_subscriptions
    "scaffolded_regions"       = local.scaffolded_regions
    "scaffolded_environments"  = local.scaffolded_environments
  }
}
