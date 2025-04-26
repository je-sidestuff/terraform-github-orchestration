# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "input_json" {
  description = <<EOF
The set or arguments to pass in to the parent module, encoded as a json blob.
All variables will be taken from the top level keys of the same name.
EOF
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "var_files" {
  description = "A list of var files to make available directly from the local filesystem."
  type        = list(string)
  default     = []
}