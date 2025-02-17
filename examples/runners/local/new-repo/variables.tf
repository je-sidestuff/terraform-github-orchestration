# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "github_pat" {
  description = "The personal access token used to authenticate for the runner-creation interactions."
  type        = string
  sensitive   = true
}

variable "github_org" {
  description = "The organization which you are logging in on behalf of. TODO this is currently mandatory because of a provider bug."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the local self-hosted runner."
  type        = string
  default     = "generate"
}

variable "output_file" {
  description = "The name of the file the workflow will write to. If relative it will be prefixed with the root dir."
  type        = string
  default     = "action-runner-output.txt"
}

variable "output_message" {
  description = "The text to write to the output file."
  type        = string
  default     = "Hello from github!"
}
