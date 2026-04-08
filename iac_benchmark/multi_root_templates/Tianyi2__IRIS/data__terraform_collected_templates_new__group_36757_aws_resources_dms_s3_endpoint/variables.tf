# Required variables
variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "endpoint_id" {
  description = "Database endpoint identifier. Identifiers must contain from 1 to 255 alphanumeric characters or hyphens, begin with a letter, contain only ASCII letters, digits, and hyphens, not end with a hyphen, and not contain two consecutive hyphens"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,253}[a-zA-Z0-9]$", var.endpoint_id)) || can(regex("^[a-zA-Z]$", var.endpoint_id))
    error_message = "resource_aws_dms_s3_endpoint, endpoint_id must contain from 1 to 255 alphanumeric characters or hyphens, begin with a letter, contain only ASCII letters, digits, and hyphens, not end with a hyphen, and not contain two consecutive hyphens."
  }
}

variable "endpoint_type" {
  description = "Type of endpoint"
  type        = string

  validation {
    condition     = contains(["source", "target"], var.endpoint_type)
    error_message = "resource_aws_dms_s3_endpoint, endpoint_type must be either 'source' or 'target'."
  }
}

variable "service_access_role_arn" {
  description = "ARN of the IAM role with permissions to the S3 Bucket"
  type        = string
}

# Optional variables
variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "add_column_name" {
  description = "Whether to add column name information to the .csv output file"
  type        = bool
  default     = false
}

variable "add_trailing_padding_character" {
  description = "Whether to add padding"
  type        = bool
  default     = false
}

variable "bucket_folder" {
  description = "S3 object prefix"
  type        = string
  default     = null
}

variable "canned_acl_for_objects" {
  description = "Predefined (canned) access control list for objects created in an S3 bucket"
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "private", "public-read", "public-read-write", "authenticated-read", "aws-exec-read", "bucket-owner-read", "bucket-owner-full-control"], var.canned_acl_for_objects)
    error_message = "resource_aws_dms_s3_endpoint, canned_acl_for_objects must be one of: none, private, public-read, public-read-write, authenticated-read, aws-exec-read, bucket-owner-read, bucket-owner-full-control."
  }
}

variable "cdc_inserts_and_updates" {
  description = "Whether to write insert and update operations to .csv or .parquet output files"
  type        = bool
  default     = false
}

variable "cdc_inserts_only" {
  description = "Whether to write insert operations to .csv or .parquet output files"
  type        = bool
  default     = false
}

variable "cdc_max_batch_interval" {
  description = "Maximum length of the interval, defined in seconds, after which to output a file to Amazon S3"
  type        = number
  default     = null
}

variable "cdc_min_file_size" {
  description = "Minimum file size condition as defined in kilobytes to output a file to Amazon S3"
  type        = number
  default     = null
}

variable "cdc_path" {
  description = "Folder path of CDC files"
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "ARN for the certificate"
  type        = string
  default     = ""
}

variable "compression_type" {
  description = "Set to compress target files"
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["GZIP", "NONE"], var.compression_type)
    error_message = "resource_aws_dms_s3_endpoint, compression_type must be either 'GZIP' or 'NONE'."
  }
}

variable "csv_delimiter" {
  description = "Delimiter used to separate columns in the source files"
  type        = string
  default     = ","
}

variable "csv_no_sup_value" {
  description = "String to use for all columns not included in the supplemental log"
  type        = string
  default     = null
}

variable "csv_null_value" {
  description = "String to as null when writing to the target"
  type        = string
  default     = null
}

variable "csv_row_delimiter" {
  description = "Delimiter used to separate rows in the source files"
  type        = string
  default     = null
}

variable "data_format" {
  description = "Output format for the files that AWS DMS uses to create S3 objects"
  type        = string
  default     = null

  validation {
    condition     = var.data_format == null || contains(["csv", "parquet"], var.data_format)
    error_message = "resource_aws_dms_s3_endpoint, data_format must be either 'csv' or 'parquet'."
  }
}

variable "data_page_size" {
  description = "Size of one data page in bytes"
  type        = number
  default     = null
}

variable "date_partition_delimiter" {
  description = "Date separating delimiter to use during folder partitioning"
  type        = string
  default     = null

  validation {
    condition     = var.date_partition_delimiter == null || contains(["SLASH", "UNDERSCORE", "DASH", "NONE"], var.date_partition_delimiter)
    error_message = "resource_aws_dms_s3_endpoint, date_partition_delimiter must be one of: SLASH, UNDERSCORE, DASH, NONE."
  }
}

variable "date_partition_enabled" {
  description = "Partition S3 bucket folders based on transaction commit dates"
  type        = bool
  default     = false
}

variable "date_partition_sequence" {
  description = "Date format to use during folder partitioning"
  type        = string
  default     = null

  validation {
    condition     = var.date_partition_sequence == null || contains(["YYYYMMDD", "YYYYMMDDHH", "YYYYMM", "MMYYYYDD", "DDMMYYYY"], var.date_partition_sequence)
    error_message = "resource_aws_dms_s3_endpoint, date_partition_sequence must be one of: YYYYMMDD, YYYYMMDDHH, YYYYMM, MMYYYYDD, DDMMYYYY."
  }
}

variable "date_partition_timezone" {
  description = "Convert the current UTC time to a timezone"
  type        = string
  default     = null
}

variable "detach_target_on_lob_lookup_failure_parquet" {
  description = "Undocumented argument for use as directed by AWS Support"
  type        = bool
  default     = null
}

variable "dict_page_size_limit" {
  description = "Maximum size in bytes of an encoded dictionary page of a column"
  type        = number
  default     = null
}

variable "enable_statistics" {
  description = "Whether to enable statistics for Parquet pages and row groups"
  type        = bool
  default     = true
}

variable "encoding_type" {
  description = "Type of encoding to use"
  type        = string
  default     = null

  validation {
    condition     = var.encoding_type == null || contains(["rle_dictionary", "plain", "plain_dictionary"], var.encoding_type)
    error_message = "resource_aws_dms_s3_endpoint, encoding_type must be one of: rle_dictionary, plain, plain_dictionary."
  }
}

variable "encryption_mode" {
  description = "Server-side encryption mode that you want to encrypt your .csv or .parquet object files copied to S3"
  type        = string
  default     = null

  validation {
    condition     = var.encryption_mode == null || contains(["SSE_S3", "SSE_KMS"], var.encryption_mode)
    error_message = "resource_aws_dms_s3_endpoint, encryption_mode must be either 'SSE_S3' or 'SSE_KMS'."
  }
}

variable "expected_bucket_owner" {
  description = "Bucket owner to prevent sniping. Value is an AWS account ID"
  type        = string
  default     = null
}

variable "external_table_definition" {
  description = "JSON document that describes how AWS DMS should interpret the data. Required for source endpoints"
  type        = string
  default     = null
}

variable "glue_catalog_generation" {
  description = "Whether to integrate AWS Glue Data Catalog with an Amazon S3 target"
  type        = bool
  default     = false
}

variable "ignore_header_rows" {
  description = "When this value is set to 1, DMS ignores the first row header in a .csv file"
  type        = number
  default     = null
}

variable "include_op_for_full_load" {
  description = "Whether to enable a full load to write INSERT operations to the .csv output files only to indicate how the rows were added to the source database"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN for the KMS key that will be used to encrypt the connection parameters"
  type        = string
  default     = null
}

variable "max_file_size" {
  description = "Maximum size (in KB) of any .csv file to be created while migrating to an S3 target during full load"
  type        = number
  default     = null

  validation {
    condition     = var.max_file_size == null || (var.max_file_size >= 1 && var.max_file_size <= 1048576)
    error_message = "resource_aws_dms_s3_endpoint, max_file_size must be between 1 and 1048576 KB."
  }
}

variable "parquet_timestamp_in_millisecond" {
  description = "Specifies the precision of any TIMESTAMP column values written to an S3 object file in .parquet format"
  type        = bool
  default     = false
}

variable "parquet_version" {
  description = "Version of the .parquet file format"
  type        = string
  default     = null

  validation {
    condition     = var.parquet_version == null || contains(["parquet-1-0", "parquet-2-0"], var.parquet_version)
    error_message = "resource_aws_dms_s3_endpoint, parquet_version must be either 'parquet-1-0' or 'parquet-2-0'."
  }
}

variable "preserve_transactions" {
  description = "Whether DMS saves the transaction order for a CDC load on the S3 target specified by cdc_path"
  type        = bool
  default     = false
}

variable "rfc_4180" {
  description = "For an S3 source, whether each leading double quotation mark has to be followed by an ending double quotation mark"
  type        = bool
  default     = true
}

variable "row_group_length" {
  description = "Number of rows in a row group"
  type        = number
  default     = null
}

variable "server_side_encryption_kms_key_id" {
  description = "When encryption_mode is SSE_KMS, ARN for the AWS KMS key"
  type        = string
  default     = null
}

variable "ssl_mode" {
  description = "SSL mode to use for the connection"
  type        = string
  default     = null

  validation {
    condition     = var.ssl_mode == null || contains(["none", "require", "verify-ca", "verify-full"], var.ssl_mode)
    error_message = "resource_aws_dms_s3_endpoint, ssl_mode must be one of: none, require, verify-ca, verify-full."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "timestamp_column_name" {
  description = "Column to add with timestamp information to the endpoint data for an Amazon S3 target"
  type        = string
  default     = null
}

variable "use_csv_no_sup_value" {
  description = "Whether to use csv_no_sup_value for columns not included in the supplemental log"
  type        = bool
  default     = null
}

variable "use_task_start_time_for_full_load_timestamp" {
  description = "When set to true, uses the task start time as the timestamp column value instead of the time data is written to target"
  type        = bool
  default     = false
}

# Timeout variables
variable "timeout_create" {
  description = "Timeout for creating the endpoint"
  type        = string
  default     = "5m"
}

variable "timeout_delete" {
  description = "Timeout for deleting the endpoint"
  type        = string
  default     = "5m"
}