locals {
  
  input_json = var.json_in_base64 ? replace(base64decode(var.input_json), "\n", "") : var.input_json
}

module "this" {
  source = "../"

  input_targets = jsondecode(local.input_json).input_targets

  subscription_id =  jsondecode(local.input_json).subscription_id

  scaffolding_root = jsondecode(local.input_json).scaffolding_root

  backend = try(jsondecode(local.input_json).backend, "")

  var_file_strings = try(jsondecode(local.input_json).var_file_strings, {})

  var_files = var.var_files
}
