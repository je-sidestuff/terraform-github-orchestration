# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name for the local self-hosted runner."
  type        = string
}

variable "github_pat" {
  description = "The personal access token used to authenticate for the runner-creation interactions."
  type        = string
  sensitive   = true
}

variable "repo_full_name" {
  description = "The full name of the repository to scope the local runner to."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "clean_up_runner_dir_on_destroy" {
  description = "Whether to delete the runner dir when the module is destroyed."
  type        = bool
  default     = true
}

variable "delay_execution_on" {
  description = "The runner will only be executed once it is installed and once this value is resolved."
  type        = string
  default     = ""
}

variable "execution_time" {
  description = "The runner will be executed for this length of time. Set to an empty string to skip execution."
  type        = string
  default     = "120s"
}

variable "install_dir" {
  description = <<EOT
The working directory for the self-hosted runner. Defaults to '<root-dir>/actions-runner' if not populated.
This directory will be created if it does not exist.
The directory will be deleted on destroy if clean_up_runner_dir_on_destroy is true.
EOT
  type        = string
  default     = ""
}

variable "labels" {
  description = "The labels that will be applied to this runner in addition to the default labels."
  type        = list(string)
  default     = ["terraform"]
}

variable "local_cache_dir" {
  description = "The directory where the downloaded file will be cached for re-use. (Useful if creating and destroying instances)"
  type        = string
  default     = ""
}

variable "log_file" {
  description = "The absolute path of the file where the action runner log will be redirected."
  type        = string
  default     = ""
}

variable "runner_group" {
  description = "The runnergroup name for the self-hosted runner. Defaults to 'Default'."
  type        = string
  default     = "Default"
}

variable "work_dir" {
  description = "The working directory for the self-hosted runner. Defaults to '_work' within the install_dir."
  type        = string
  default     = "_work"
}
