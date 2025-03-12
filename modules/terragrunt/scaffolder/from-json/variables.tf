# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "scaffolding_root" {
  description = "The directory within which the terragrunt content will be scaffolded. The 'terragrunt' folder will be created _within_ this path."
  type        = string
}

variable "input_targets_json" {
  description = <<EOF
The list of targets to scaffold.
EOF
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
