locals {
  name_prefix  = var.name == "generate" ? "ex-${random_string.random.result}" : var.name
  example_repo = "${local.name_prefix}-repo"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

module "example_smart_template_deployment" {
  source = "../../../..//modules/repos/smart-template/deployment"

  name                 = local.example_repo
  github_pat           = var.github_pat
  init_payload_content = var.init_payload_content
  source_owner         = var.source_owner
  template_repo_name   = var.template_repo_name
}
