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

variable "source_owner" {
  description = "The owner of the smart template source repo"
  type        = string
}

variable "template_repo_name" {
  description = "The name of the smart template source repo"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the repository we will create from this template."
  type        = string
  default     = "generate"
}

variable "init_payload_content" {
  description = "A json string uused to drive the initialization of the repo."
  type        = string
  default     = "{\"filename\": \"INITIALIZED\"}"
}

variable "timeout_in_seconds" {
  description = "The number of seconds to allow for repo init."
  type        = number
  default     = 300
  validation {
    condition     = var.timeout_in_seconds > 20
    error_message = "The timeout_in_seconds must be greater than 20."
  }
}
