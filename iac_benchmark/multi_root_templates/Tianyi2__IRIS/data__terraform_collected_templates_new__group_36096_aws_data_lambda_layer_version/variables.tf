variable "layer_name" {
  description = "Name of the Lambda layer"
  type        = string
}

variable "compatible_architecture" {
  description = "Specific architecture the layer version must support. Conflicts with version. If specified, the latest available layer version supporting the provided architecture will be used"
  type        = string
  default     = null
}

variable "compatible_runtime" {
  description = "Specific runtime the layer version must support. Conflicts with version. If specified, the latest available layer version supporting the provided runtime will be used"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "layer_version" {
  description = "Specific layer version. Conflicts with compatible_runtime and compatible_architecture. If omitted, the latest available layer version will be used"
  type        = number
  default     = null
}