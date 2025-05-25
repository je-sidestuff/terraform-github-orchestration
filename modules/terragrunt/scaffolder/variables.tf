# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "scaffolding_root" {
  description = "The directory within which the terragrunt content will be scaffolded. The 'terragrunt' folder will be created _within_ this path."
  type        = string
}

variable "input_targets" {
  description = <<EOF
The list of targets to scaffold.
EOF
  type        = map(
    object({
        repo = string
        path = string
        ref = optional(string, "main")
        description = optional(string)
        vars = optional(map(string), {})
        var_file_strings = optional(list(string), [])
        var_files = optional(list(string), [])
        placement = map(string)
    })
)
}

variable "subscription_id" {
  description = "A temporary subscription ID - to be generalized and aonomized next increment"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

# variable "backend_generators" { -- coming soon
#   description = "This map of strings maps filenames to generator file content to be placed in _envcommon/backends/"
#   type        = map(string)
#   default     = {}
# }

# variable "provider_generators" { -- coming soon
#   description = "This map of strings maps filenames to generator file content to be placed in _envcommon/providers/"
#   type        = map(string)
#   default     = {}
# }

variable "var_file_strings" {
  description = "The map of var files to make available to use in the terragrunt scaffold. Name of file to content string. These are necessary for multi-line vars."
  type        = map(string)
  default     = {}
}

variable "var_files" {
  description = "A list of var files to make available directly from the local filesystem."
  type        = list(string)
  default     = []
}
