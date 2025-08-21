
module "azure_backend_generator" {
    for_each = {    for generator_name, generator_details in var.backend_generators:
      generator_name => generator_details if generator_details.type=="azure"
    }

    source = "backend/azure"

    inputs = generator_details.arguments

    subtype = generator_details.subtype
}

resource "local_file" "azure_backend_generator" {
  for_each = {    for generator_name, generator_details in var.backend_generators:
      generator_name => generator_details if generator_details.type=="azure"
    }

  filename = "${var.scaffolding_root}/terragrunt/root.hcl"
  content  = module.azure_backend_generator[each.key].content
}
