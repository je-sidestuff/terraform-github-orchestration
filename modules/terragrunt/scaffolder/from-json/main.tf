module "this" {
  source = "../"

  input_targets = jsondecode(var.input_json).input_targets

  subscription_id =  jsondecode(var.input_json).subscription_id

  scaffolding_root = jsondecode(var.input_json).scaffolding_root

  backend = try(jsondecode(var.input_json).backend, "")

  var_file_strings = try(jsondecode(var.input_json).var_file_strings, {})

  var_files = var.var_files
}
