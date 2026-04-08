variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_backup_region_settings, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "resource_type_opt_in_preference" {
  description = "A map of service names to their opt-in preferences for the Region. See AWS Documentation on which services support backup."
  type        = map(bool)

  validation {
    condition     = length(var.resource_type_opt_in_preference) > 0
    error_message = "resource_aws_backup_region_settings, resource_type_opt_in_preference must contain at least one service mapping."
  }

  validation {
    condition = alltrue([
      for service, enabled in var.resource_type_opt_in_preference :
      contains([
        "Aurora",
        "CloudFormation",
        "DocumentDB",
        "DSQL",
        "DynamoDB",
        "EBS",
        "EC2",
        "EFS",
        "FSx",
        "Neptune",
        "Redshift",
        "Redshift Serverless",
        "RDS",
        "S3",
        "SAP HANA on Amazon EC2",
        "Storage Gateway",
        "VirtualMachine"
      ], service)
    ])
    error_message = "resource_aws_backup_region_settings, resource_type_opt_in_preference contains invalid service names. Valid services are: Aurora, CloudFormation, DocumentDB, DSQL, DynamoDB, EBS, EC2, EFS, FSx, Neptune, Redshift, Redshift Serverless, RDS, S3, SAP HANA on Amazon EC2, Storage Gateway, VirtualMachine."
  }
}

variable "resource_type_management_preference" {
  description = "A map of service names to their full management preferences for the Region. For more information, see AWS Documentation on what full management is and which services support full management."
  type        = map(bool)
  default     = {}

  validation {
    condition = alltrue([
      for service, enabled in var.resource_type_management_preference :
      contains([
        "CloudFormation",
        "DSQL",
        "DynamoDB",
        "EFS"
      ], service)
    ])
    error_message = "resource_aws_backup_region_settings, resource_type_management_preference contains invalid service names. Valid services are: CloudFormation, DSQL, DynamoDB, EFS."
  }
}