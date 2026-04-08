# aws_config_organization_managed_rule - resourcesTagged
variable "required_tags" {
  # https://docs.aws.amazon.com/config/latest/developerguide/required-tags.html
  description = "A map of the required tag keys and/or values to evaluate"
  type        = map(string)
  default = {
    "tag1Key" = "owner"
  }
}

# aws_config_organization_managed_rule - accessKeyRotated
variable "accessKeyRotated_maxAccessKeyAge" {
  description = "Every Access Key will be defined as Non-Compliant after exceeding the number of days defined in this variable"
  default     = 30
}

# aws_config_organization_managed_rule - dbInstanceBackupEnabled
variable "dbInstanceBackupEnabled_RetentionPeriod" {
  description = "The retention period in days for the RDS Databases to check"
  default     = 30
}

variable "dbInstanceBackupEnabled_PreferredBackupWindow" {
  description = "The format is hh24:min-hh24:min. Example: 23:00-02:00"
  default     = "22:00-24:00"
}

variable "dbInstanceBackupEnabled_CheckReadReplicas" {
  description = "Defines if AWS Config should Check if the RDS instance has backups enabled for the ReadReplicas"
  default     = true
}

# aws_config_organization_managed_rule - elbLoggingEnabled
variable "elbLoggingEnabled_s3BucketNames" {
  description = "Comma separated list of S3 bucket names for ELB to deliver the log files"
  default     = "backup"
}

# aws_lambda_function - s3_webserver_buckets
variable "lambda_timeout" {
  description = "The timeout for the custom lambda scripts which define more custom AWS Config rules"
  default     = 30
}

