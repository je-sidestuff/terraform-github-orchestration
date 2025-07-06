locals {
  
  input_json = var.json_in_base64 ? replace(base64decode(var.input_json), "\n", "") : var.input_json

  subscription_id = var.subscription_id == null ? jsondecode(local.input_json).subscription_id : var.subscription_id

  scaffolding_root = var.scaffolding_root == null ? jsondecode(local.input_json).scaffolding_root : var.scaffolding_root
}

module "this" {
  source = "../"

  input_targets = jsondecode(local.input_json).input_targets

  subscription_id = local.subscription_id

  scaffolding_root = local.scaffolding_root

  var_file_strings = try(jsondecode(local.input_json).var_file_strings, {})

  var_files = var.var_files
}
