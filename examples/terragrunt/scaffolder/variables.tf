# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "subscription_id" {
  description = "A temporary subscription ID - to be generalized and aonomized next increment"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "naming_prefix" {
  type        = string
  description = "A prefix to use for naming the Container Apps Environment."
  default     = "generate"
}
