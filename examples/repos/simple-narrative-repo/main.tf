locals {
  name_prefix               = var.name == "generate" ? "ex-${random_string.random.result}" : var.name
  example_presentation_repo = "${local.name_prefix}-presentation"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

module "narrative_repo" {
  source = "../../..//modules/repos/revisionist-historian"

  name = local.example_presentation_repo
}
