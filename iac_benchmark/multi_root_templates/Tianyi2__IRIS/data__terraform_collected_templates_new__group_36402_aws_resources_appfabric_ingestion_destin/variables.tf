variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "app_bundle_arn" {
  description = "The Amazon Resource Name (ARN) of the app bundle to use for the request"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:appfabric:[a-z0-9-]+:[0-9]{12}:appbundle/[a-zA-Z0-9-]+$", var.app_bundle_arn))
    error_message = "resource_aws_appfabric_ingestion_destination, app_bundle_arn must be a valid ARN format."
  }
}

variable "ingestion_arn" {
  description = "The Amazon Resource Name (ARN) of the ingestion to use for the request"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:appfabric:[a-z0-9-]+:[0-9]{12}:appbundle/[a-zA-Z0-9-]+/ingestion/[a-zA-Z0-9-]+$", var.ingestion_arn))
    error_message = "resource_aws_appfabric_ingestion_destination, ingestion_arn must be a valid ARN format."
  }
}

variable "destination_configuration" {
  description = "Contains information about the destination of ingested data"
  type = object({
    audit_log = object({
      destination = object({
        firehose_stream = optional(object({
          streamName = string
        }))
        s3_bucket = optional(object({
          bucketName = string
          prefix     = optional(string)
        }))
      })
    })
  })

  validation {
    condition = (
      var.destination_configuration.audit_log.destination.firehose_stream != null &&
      var.destination_configuration.audit_log.destination.s3_bucket == null
      ) || (
      var.destination_configuration.audit_log.destination.firehose_stream == null &&
      var.destination_configuration.audit_log.destination.s3_bucket != null
    )
    error_message = "resource_aws_appfabric_ingestion_destination, destination_configuration must specify exactly one destination (either firehose_stream or s3_bucket)."
  }

  validation {
    condition = var.destination_configuration.audit_log.destination.firehose_stream == null || (
      var.destination_configuration.audit_log.destination.firehose_stream.streamName != null &&
      var.destination_configuration.audit_log.destination.firehose_stream.streamName != ""
    )
    error_message = "resource_aws_appfabric_ingestion_destination, destination_configuration firehose_stream streamName is required when firehose_stream is specified."
  }

  validation {
    condition = var.destination_configuration.audit_log.destination.s3_bucket == null || (
      var.destination_configuration.audit_log.destination.s3_bucket.bucketName != null &&
      var.destination_configuration.audit_log.destination.s3_bucket.bucketName != ""
    )
    error_message = "resource_aws_appfabric_ingestion_destination, destination_configuration s3_bucket bucketName is required when s3_bucket is specified."
  }
}

variable "processing_configuration" {
  description = "Contains information about how ingested data is processed"
  type = object({
    audit_log = object({
      format = string
      schema = string
    })
  })

  validation {
    condition     = contains(["json", "parquet"], var.processing_configuration.audit_log.format)
    error_message = "resource_aws_appfabric_ingestion_destination, processing_configuration format must be one of: json, parquet."
  }

  validation {
    condition     = contains(["ocsf", "raw"], var.processing_configuration.audit_log.schema)
    error_message = "resource_aws_appfabric_ingestion_destination, processing_configuration schema must be one of: ocsf, raw."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create)) && can(regex("^[0-9]+[smh]$", var.timeouts.update)) && can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_appfabric_ingestion_destination, timeouts must be in format like '5m', '30s', '1h'."
  }
}