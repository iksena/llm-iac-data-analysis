variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "engine_version" {
  description = "Engine version that the package is compatible with. This argument is required and only valid when package_type is ZIP-PLUGIN. Format: OpenSearch_X.Y or Elasticsearch_X.Y, where X and Y are the major and minor version numbers, respectively."
  type        = string
  default     = null

  validation {
    condition = var.engine_version == null || can(regex("^(OpenSearch|Elasticsearch)_[0-9]+\\.[0-9]+$", var.engine_version))
    error_message = "resource_aws_opensearch_package, engine_version must be in format OpenSearch_X.Y or Elasticsearch_X.Y where X and Y are major and minor version numbers."
  }
}

variable "package_name" {
  description = "Unique name for the package."
  type        = string

  validation {
    condition     = length(var.package_name) > 0
    error_message = "resource_aws_opensearch_package, package_name must not be empty."
  }
}

variable "package_type" {
  description = "The type of package. Valid values are TXT-DICTIONARY, ZIP-PLUGIN, PACKAGE-LICENSE and PACKAGE-CONFIG."
  type        = string

  validation {
    condition     = contains(["TXT-DICTIONARY", "ZIP-PLUGIN", "PACKAGE-LICENSE", "PACKAGE-CONFIG"], var.package_type)
    error_message = "resource_aws_opensearch_package, package_type must be one of: TXT-DICTIONARY, ZIP-PLUGIN, PACKAGE-LICENSE, PACKAGE-CONFIG."
  }
}

variable "package_source" {
  description = "Configuration block for the package source options."
  type = object({
    s3_bucket_name = string
    s3_key         = string
  })

  validation {
    condition     = length(var.package_source.s3_bucket_name) > 0
    error_message = "resource_aws_opensearch_package, s3_bucket_name must not be empty."
  }

  validation {
    condition     = length(var.package_source.s3_key) > 0
    error_message = "resource_aws_opensearch_package, s3_key must not be empty."
  }
}

variable "package_description" {
  description = "Description of the package."
  type        = string
  default     = null
}