locals {
  
  content = {
    managed_service_identity = var.subtype != "managed_service_identity" ? "" : <<EOT
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "${var.arguments.resource_group_name}"
    storage_account_name = "${var.arguments.storage_account_name}"
    container_name       = "${var.arguments.container_name}"
    key                  = "$${path_relative_to_include()}/terraform.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
    }
}
EOF
}
EOT

    user = var.subtype != "user" ? "" : <<EOT
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "${var.arguments.resource_group_name}"
    storage_account_name = "${var.arguments.storage_account_name}"
    container_name       = "${var.arguments.container_name}"
    key                  = "$${path_relative_to_include()}/terraform.tfstate"
    }
}
EOF
}
EOT
  }
}
