# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "input_json" {
  description = <<EOF
The set or arguments to pass in to the parent module, encoded as a json blob.
All variables will be taken from the top level keys of the same name.

If the 'json_in_base64' variable is true then the json will be base64 decoded.
EOF
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "json_in_base64" {
  description = "Whether the input_json is base64 encoded."
  type        = bool
  default     = false
}

variable "var_files" {
  description = "A list of var files to make available directly from the local filesystem."
  type        = list(string)
  default     = []
}

variable "subscription_id" {
  description = "An optional input for the Azure subscription. Will be taken from the input json if not provided."
  type        = string
  default     = null
}

variable "scaffolding_root" {
  description = "An optional input for the scaffolding root. Will be taken from the input json if not provided."
  type        = string
  default     = null
}

#
# These variables are a sign that we should collapse the 'from json' into an
# additional input to the main module rather than having a second module.
#

variable "backend_generators" {
  description = "Backend name to backend type and args."
  type        = map(object({
    backend_type    = string
    backend_subtype = optional(string)
    arguments       = map(string)
  }))
  default     = {}
}

variable "provider_generators" {
  description = "Provider name to provider type and args. The provider_type is in the format "
  type        = map(object({
    provider_type    = string
    provider_subtype = optional(string)
    arguments        = map(string)
  }))
  default     = {}
}
