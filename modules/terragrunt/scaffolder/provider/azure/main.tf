locals {
  
  content = {
    managed_service_identity = var.subtype != "managed_service_identity" ? "" : <<EOT
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  subscription_id                 = "${var.arguments.subscription_id}"
  resource_provider_registrations = "all"
  use_msi                         = true
  use_oidc                        = true
  client_id                       = "${var.arguments.client_id}"
  tenant_id                       = "${var.arguments.tenant_id}"
  features {}
}
EOF
}

EOT

    user = var.subtype != "user" ? "" : <<EOT
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  subscription_id                 = "${var.arguments.subscription_id}"
  resource_provider_registrations = "all"
  features {}
}
EOF
}

EOT
  }
}
