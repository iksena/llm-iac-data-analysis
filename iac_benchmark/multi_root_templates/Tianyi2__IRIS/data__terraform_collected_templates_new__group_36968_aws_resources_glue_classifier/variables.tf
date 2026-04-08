variable "name" {
  description = "The name of the classifier."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_glue_classifier, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "csv_classifier" {
  description = "A classifier for CSV content."
  type = object({
    allow_single_column        = optional(bool)
    contains_header            = optional(string)
    custom_datatype_configured = optional(bool)
    custom_datatypes           = optional(list(string))
    delimiter                  = optional(string)
    disable_value_trimming     = optional(bool)
    header                     = optional(list(string))
    quote_symbol               = optional(string)
    serde                      = optional(string)
  })
  default = null

  validation {
    condition = var.csv_classifier != null ? (
      var.csv_classifier.contains_header == null ||
      contains(["ABSENT", "PRESENT", "UNKNOWN"], var.csv_classifier.contains_header)
    ) : true
    error_message = "resource_aws_glue_classifier, contains_header must be one of 'ABSENT', 'PRESENT', or 'UNKNOWN'."
  }

  validation {
    condition = var.csv_classifier != null && var.csv_classifier.custom_datatypes != null ? (
      alltrue([for dt in var.csv_classifier.custom_datatypes :
      contains(["BINARY", "BOOLEAN", "DATE", "DECIMAL", "DOUBLE", "FLOAT", "INT", "LONG", "SHORT", "STRING", "TIMESTAMP"], dt)])
    ) : true
    error_message = "resource_aws_glue_classifier, custom_datatypes must contain only valid values: BINARY, BOOLEAN, DATE, DECIMAL, DOUBLE, FLOAT, INT, LONG, SHORT, STRING, TIMESTAMP."
  }

  validation {
    condition = var.csv_classifier != null ? (
      var.csv_classifier.serde == null ||
      contains(["OpenCSVSerDe", "LazySimpleSerDe", "None"], var.csv_classifier.serde)
    ) : true
    error_message = "resource_aws_glue_classifier, serde must be one of 'OpenCSVSerDe', 'LazySimpleSerDe', or 'None'."
  }
}

variable "grok_classifier" {
  description = "A classifier that uses grok patterns."
  type = object({
    classification  = string
    custom_patterns = optional(string)
    grok_pattern    = string
  })
  default = null

  validation {
    condition = var.grok_classifier != null ? (
      length(var.grok_classifier.classification) > 0 &&
      length(var.grok_classifier.grok_pattern) > 0
    ) : true
    error_message = "resource_aws_glue_classifier, grok_classifier classification and grok_pattern are required and must not be empty."
  }
}

variable "json_classifier" {
  description = "A classifier for JSON content."
  type = object({
    json_path = string
  })
  default = null

  validation {
    condition = var.json_classifier != null ? (
      length(var.json_classifier.json_path) > 0
    ) : true
    error_message = "resource_aws_glue_classifier, json_classifier json_path is required and must not be empty."
  }
}

variable "xml_classifier" {
  description = "A classifier for XML content."
  type = object({
    classification = string
    row_tag        = string
  })
  default = null

  validation {
    condition = var.xml_classifier != null ? (
      length(var.xml_classifier.classification) > 0 &&
      length(var.xml_classifier.row_tag) > 0
    ) : true
    error_message = "resource_aws_glue_classifier, xml_classifier classification and row_tag are required and must not be empty."
  }
}