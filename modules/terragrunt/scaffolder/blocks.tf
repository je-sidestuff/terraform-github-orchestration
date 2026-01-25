
module "azure_backend_generator" {
    for_each = {    for generator_name, generator_details in var.backend_generators:
      generator_name => generator_details if generator_details.backend_type=="azure"
    }

    source = "./backend/azure"

    arguments = each.value.arguments

    subtype = each.value.backend_subtype
}

module "azure_provider_generator" {
    for_each = {    
      for generator_name, generator_details in var.provider_generators:
      generator_name => generator_details if generator_details.provider_type=="azure"
    }

    source = "./provider/azure"

    arguments = each.value.arguments

    subtype = each.value.provider_subtype
}

locals {
  # backend_generator_content = ""
  backend_generator_content = join("", concat([""], [
    for generator_name, generator_details in var.backend_generators:
    module.azure_backend_generator[generator_name].content
  ]))

  provider_generator_content = join("", concat([""], [
    for generator_name, generator_details in var.provider_generators:
    module.azure_provider_generator[generator_name].content
  ]))
}
