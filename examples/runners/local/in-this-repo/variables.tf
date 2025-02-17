# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "github_pat" {
  description = "The personal access token used to authenticate for the runner-creation interactions."
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "github_user" {
  description = "The name of user that owns the specified repository. If left blank the current authenticated user will be selected."
  type        = string
  default     = ""
}

variable "name" {
  description = "The name for the local self-hosted runner."
  type        = string
  default     = "generate"
}
