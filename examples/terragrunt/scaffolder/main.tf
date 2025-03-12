locals {
  naming_prefix = var.naming_prefix == "generate" ? "ex-${random_string.random.result}" : var.naming_prefix
  resource_group_name = "${local.naming_prefix}-rg"
  storage_account_name = "${replace(local.naming_prefix, "-", "")}sa"
  storage_container_name = "rootstate"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

module "scaffolding" {
  source = "../../..//modules/terragrunt/scaffolder"

  scaffolding_root = path.root

  subscription_id = var.subscription_id

  input_targets = {
    storage_account = {
      repo = "je-sidestuff/terraform-azure-simple-modules"
      path = "modules/data-stores/storage-account"
      branch = "environment_deployment_support"
      placement = {
        "region": "eastus",
        "env": "default",
        "subscription": "sandbox"
      }
    }
  }

#   source = "../../..//modules/terragrunt/scaffolder/from-json"
  
#   input_targets_json = <<EOF
# {
#   "storage_account" : {
#     "repo": "je-sidestuff/terraform-azure-simple-modules",
#     "path": "modules/data-stores/storage-account",
#     "branch": "environment_deployment_support",
#     "placement": {
#       "region": "eastus",
#       "env": "default",
#       "subscription": "sandbox"
#     }
#   }
# }
# EOF
}

resource "terraform_data" "cleanup" {
  # Remove the terragrunt directory on destroy
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${path.root}/terragrunt"
  }
}

output "scaffolding_output" {
  value = module.scaffolding
}
