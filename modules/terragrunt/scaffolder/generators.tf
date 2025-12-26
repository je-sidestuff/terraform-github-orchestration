
module "azure_backend_generator" {
    for_each = {    for generator_name, generator_details in var.backend_generators:
      generator_name => generator_details if generator_details.type=="azure"
    }

    source = "backend/azure"

    arguments = generator_details.arguments

    subtype = generator_details.subtype
}

module "azure_provider_generator" {
    for_each = {    for generator_name, generator_details in var.provider_generators:
      generator_name => generator_details if generator_details.type=="azure"
    }

    source = "provider/azure"

    arguments = generator_details.arguments

    subtype = generator_details.subtype
}

locals {

  backend_generator_content = concat("", [
    for generator_name, generator_details in var.backend_generators:
    module.local_file.azure_backend_generator.content
  ])

  provider_generator_content = concat("", [
    for generator_name, generator_details in var.provider_generators:
    module.local_file.azure_provider_generator.content
  ])
}
