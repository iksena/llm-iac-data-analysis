variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "kms_server_side_encryption" {
  description = "Information about whether DevOps Guru is configured to encrypt server-side data using KMS."
  type = object({
    kms_key_id    = optional(string)
    opt_in_status = optional(string)
    type          = optional(string)
  })

  validation {
    condition     = var.kms_server_side_encryption.opt_in_status == null || contains(["DISABLED", "ENABLED"], var.kms_server_side_encryption.opt_in_status)
    error_message = "resource_aws_devopsguru_service_integration, kms_server_side_encryption.opt_in_status must be either 'DISABLED' or 'ENABLED'."
  }

  validation {
    condition     = var.kms_server_side_encryption.type == null || contains(["CUSTOMER_MANAGED_KEY", "AWS_OWNED_KMS_KEY"], var.kms_server_side_encryption.type)
    error_message = "resource_aws_devopsguru_service_integration, kms_server_side_encryption.type must be either 'CUSTOMER_MANAGED_KEY' or 'AWS_OWNED_KMS_KEY'."
  }
}

variable "logs_anomaly_detection" {
  description = "Information about whether DevOps Guru is configured to perform log anomaly detection on Amazon CloudWatch log groups."
  type = object({
    opt_in_status = optional(string)
  })

  validation {
    condition     = var.logs_anomaly_detection.opt_in_status == null || contains(["DISABLED", "ENABLED"], var.logs_anomaly_detection.opt_in_status)
    error_message = "resource_aws_devopsguru_service_integration, logs_anomaly_detection.opt_in_status must be either 'DISABLED' or 'ENABLED'."
  }
}

variable "ops_center" {
  description = "Information about whether DevOps Guru is configured to create an OpsItem in AWS Systems Manager OpsCenter for each created insight."
  type = object({
    opt_in_status = optional(string)
  })

  validation {
    condition     = var.ops_center.opt_in_status == null || contains(["DISABLED", "ENABLED"], var.ops_center.opt_in_status)
    error_message = "resource_aws_devopsguru_service_integration, ops_center.opt_in_status must be either 'DISABLED' or 'ENABLED'."
  }
}