locals {
  naming_prefix = var.naming_prefix == "generate" ? "ex-${random_string.random.result}" : var.naming_prefix
  resource_group_name = "${local.naming_prefix}-sa-rg"
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
      vars = {
        "ResourceGroupName" = local.resource_group_name
        "Name" = local.storage_account_name
        "CreateResourceGroup" = "true"
        "Location" = "eastus"
      }
    }
  }
}

module "scaffolding_from_json" {
  source = "../../..//modules/terragrunt/scaffolder/from-json"
  
  input_json = <<EOF
{
  "scaffolding_root" : "${path.root}/from-json",
  "subscription_id" : "${var.subscription_id}",
  "input_targets" : {
    "storage_account" : {
      "repo": "je-sidestuff/terraform-azure-simple-modules",
      "path": "modules/data-stores/storage-account",
      "branch": "environment_deployment_support",
      "placement": {
        "region": "eastus",
        "env": "default",
        "subscription": "sandbox"
      },
      "vars": {
        "ResourceGroupName": "${local.resource_group_name}",
        "Name": "${local.storage_account_name}",
        "CreateResourceGroup": "true",
        "Location": "eastus"
      }
    }
  }
}
EOF
}

resource "terraform_data" "cleanup" {
  # Remove the terragrunt directory on destroy
  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
rm -rf ${path.root}/terragrunt"
rm -rf ${path.root}/from-json/terragrunt"
EOF
  }
}
