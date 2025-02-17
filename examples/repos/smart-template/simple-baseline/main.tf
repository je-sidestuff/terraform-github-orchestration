locals {
  name_prefix           = var.name == "generate" ? "ex-${random_string.random.result}" : var.name
  example_template_repo = "${local.name_prefix}-template"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

module "example_smart_template_baseline" {
  source = "../../../..//modules/repos/smart-template/baseline"

  name = local.example_template_repo
}
