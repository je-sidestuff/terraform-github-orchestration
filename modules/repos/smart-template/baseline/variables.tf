# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the smart template baseline to deploy. Must end with 'template'"
  type        = string
  validation {
    condition     = endswith(var.name, "template")
    error_message = "The name must end with 'template'."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "visibility" {
  description = "The visibility for the smart template repo to deploy. (public or private)"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "The visibility must be 'public' or 'private'."
  }
}

variable "description" {
  description = "Description of the smart template repo to deploy."
  type        = string
  default     = "A smart template repo. A new repo should be created from this template. The smart-templating process may then be triggered with a push to the main branch. ('main' or 'master' branches are supported)"
}
