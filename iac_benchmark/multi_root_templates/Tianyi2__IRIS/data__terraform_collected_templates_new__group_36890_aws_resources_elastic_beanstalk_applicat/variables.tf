variable "application" {
  type        = string
  description = "Name of the Beanstalk Application the version is associated with."

  validation {
    condition     = length(var.application) > 0
    error_message = "resource_aws_elastic_beanstalk_application_version, application must not be empty."
  }
}

variable "bucket" {
  type        = string
  description = "S3 bucket that contains the Application Version source bundle."

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_elastic_beanstalk_application_version, bucket must not be empty."
  }
}

variable "key" {
  type        = string
  description = "S3 object that is the Application Version source bundle."

  validation {
    condition     = length(var.key) > 0
    error_message = "resource_aws_elastic_beanstalk_application_version, key must not be empty."
  }
}

variable "name" {
  type        = string
  description = "Unique name for the this Application Version."

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_elastic_beanstalk_application_version, name must not be empty."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "description" {
  type        = string
  description = "Short description of the Application Version."
  default     = null
}

variable "force_delete" {
  type        = bool
  description = "On delete, force an Application Version to be deleted when it may be in use by multiple Elastic Beanstalk Environments."
  default     = null
}

variable "process" {
  type        = bool
  description = "Pre-processes and validates the environment manifest (env.yaml ) and configuration files (*.config files in the .ebextensions folder) in the source bundle. Validating configuration files can identify issues prior to deploying the application version to an environment. You must turn processing on for application versions that you create using AWS CodeBuild or AWS CodeCommit. For application versions built from a source bundle in Amazon S3, processing is optional. It validates Elastic Beanstalk configuration files. It doesn't validate your application's configuration files, like proxy server or Docker configuration."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Key-value map of tags for the Elastic Beanstalk Application Version. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  default     = {}
}