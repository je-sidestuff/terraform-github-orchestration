locals {
  name_prefix           = var.name == "generate" ? "ex-${random_string.random.result}" : var.name
  example_template_repo = "${local.name_prefix}-template"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

module "narrative_repo" {
  source = "../../..//modules/repos/revisionist-historian"
}
