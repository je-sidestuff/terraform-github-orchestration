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

variable "bootstrap_style" {
  description = "To use this module for a direct tofu/terraform bootstrap or a terragrunt bootstrap."
  type        = string
  default     = "terraform"
  validation {
    condition     = contains(["terraform", "terragrunt"], var.bootstrap_style)
    error_message = "Acceptable values for 'bootstrap_style' are 'terraform' and 'terragrunt'."
  }
}

variable "backend" {
  description = "This is the optional string that may be inserted in the root.hcl file for generating a backend. It may be an include or a literal string."
  type        = string
  default     = ""
}
