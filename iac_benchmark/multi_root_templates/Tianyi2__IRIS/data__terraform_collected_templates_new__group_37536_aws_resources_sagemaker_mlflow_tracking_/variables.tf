variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "artifact_store_uri" {
  description = "The S3 URI for a general purpose bucket to use as the MLflow Tracking Server artifact store."
  type        = string

  validation {
    condition     = can(regex("^s3://", var.artifact_store_uri))
    error_message = "resource_aws_sagemaker_mlflow_tracking_server, artifact_store_uri must be a valid S3 URI starting with 's3://'."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) for an IAM role in your account that the MLflow Tracking Server uses to access the artifact store in Amazon S3."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_sagemaker_mlflow_tracking_server, role_arn must be a valid IAM role ARN starting with 'arn:aws:iam::'."
  }
}

variable "tracking_server_name" {
  description = "A unique string identifying the tracking server name. This string is part of the tracking server ARN."
  type        = string

  validation {
    condition     = length(var.tracking_server_name) > 0 && length(var.tracking_server_name) <= 256
    error_message = "resource_aws_sagemaker_mlflow_tracking_server, tracking_server_name must be between 1 and 256 characters."
  }
}

variable "mlflow_version" {
  description = "The version of MLflow that the tracking server uses."
  type        = string
  default     = null
}

variable "automatic_model_registration" {
  description = "A list of Member Definitions that contains objects that identify the workers that make up the work team."
  type        = bool
  default     = null
}

variable "tracking_server_size" {
  description = "The size of the tracking server you want to create. You can choose between 'Small', 'Medium', and 'Large'."
  type        = string
  default     = null

  validation {
    condition     = var.tracking_server_size == null || contains(["Small", "Medium", "Large"], var.tracking_server_size)
    error_message = "resource_aws_sagemaker_mlflow_tracking_server, tracking_server_size must be one of: 'Small', 'Medium', 'Large'."
  }
}

variable "weekly_maintenance_window_start" {
  description = "The day and time of the week in Coordinated Universal Time (UTC) 24-hour standard time that weekly maintenance updates are scheduled."
  type        = string
  default     = null

  validation {
    condition     = var.weekly_maintenance_window_start == null || can(regex("^(MON|TUE|WED|THU|FRI|SAT|SUN):(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$", var.weekly_maintenance_window_start))
    error_message = "resource_aws_sagemaker_mlflow_tracking_server, weekly_maintenance_window_start must be in format 'DAY:HH:MM' (e.g., 'TUE:03:30')."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}