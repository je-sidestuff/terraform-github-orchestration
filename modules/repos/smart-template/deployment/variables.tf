# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the repo to deploy from the smart template"
  type        = string
}

variable "github_pat" {
  description = "The personal access token used to authenticate for the runner-creation interactions."
  type        = string
  sensitive   = true
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

variable "custom_actions_secrets" {
  description = "A map of custom actions secrets to add to the smart template repo."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "default_branch" {
  description = "Default branch of the deployed repo."
  type        = string
  default     = "main"
}

variable "description" {
  description = "Description of therepo created from the smart template."
  type        = string
  default     = "This repo was created from a smart template."
}

variable "init_payload_content" {
  description = "A json string uused to drive the initialization of the repo."
  type        = string
  default     = "{\"filename\": \"INITIALIZED\"}"
}

variable "visibility" {
  description = "The visibility for the smart template repo to deploy. (public or private)"
  type        = string
  default     = "private"
  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "The visibility must be 'public' or 'private'."
  }
}
