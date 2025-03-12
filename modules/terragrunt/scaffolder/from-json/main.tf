module "this" {
  source = "../"

  input_targets = jsondecode(var.input_targets_json)

  scaffolding_root = var.scaffolding_root
}
