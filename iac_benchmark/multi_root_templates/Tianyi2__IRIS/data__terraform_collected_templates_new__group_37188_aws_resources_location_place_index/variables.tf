variable "data_source" {
  description = "Specifies the geospatial data provider for the new place index"
  type        = string
}

variable "index_name" {
  description = "The name of the place index resource"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "data_source_configuration" {
  description = "Configuration block with the data storage option chosen for requesting Places"
  type = object({
    intended_use = optional(string, "SingleUse")
  })
  default = null

  validation {
    condition = var.data_source_configuration == null ? true : (
      var.data_source_configuration.intended_use == null ? true :
      contains(["SingleUse", "Storage"], var.data_source_configuration.intended_use)
    )
    error_message = "resource_aws_location_place_index, intended_use must be one of: SingleUse, Storage."
  }
}

variable "description" {
  description = "The optional description for the place index resource"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value tags for the place index"
  type        = map(string)
  default     = {}
}