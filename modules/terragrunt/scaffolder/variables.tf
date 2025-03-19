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
        branch = optional(string, "main") # TODO In the future we'll do tags
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

variable "backend" {
  description = "This is the optional string that may be inserted in the root.hcl file for generating a backend. It may be an include or a literal string."
  type        = string
  default     = ""
}

variable "var_file_strings" {
  description = "The map of var files to make available to use in the terragrunt scaffold. Name of file to content string. These are necessary for multi-line content."
  type        = map(string)
  default     = {}
}

variable "var_files" {
  description = "A list of var files to make available directly from the local filesystem."
  type        = list(string)
  default     = []
}
