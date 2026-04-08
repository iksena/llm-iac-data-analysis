variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "max_capacity" {
  description = "Max capacity of the scalable target."
  type        = number

  validation {
    condition     = var.max_capacity > 0
    error_message = "resource_aws_appautoscaling_target, max_capacity must be greater than 0."
  }
}

variable "min_capacity" {
  description = "Min capacity of the scalable target."
  type        = number

  validation {
    condition     = var.min_capacity >= 0
    error_message = "resource_aws_appautoscaling_target, min_capacity must be greater than or equal to 0."
  }

  validation {
    condition     = var.min_capacity <= var.max_capacity
    error_message = "resource_aws_appautoscaling_target, min_capacity must be less than or equal to max_capacity."
  }
}

variable "resource_id" {
  description = "Resource type and unique identifier string for the resource associated with the scaling policy."
  type        = string

  validation {
    condition     = length(var.resource_id) > 0
    error_message = "resource_aws_appautoscaling_target, resource_id cannot be empty."
  }
}

variable "role_arn" {
  description = "ARN of the IAM role that allows Application AutoScaling to modify your scalable target on your behalf."
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_appautoscaling_target, role_arn must be a valid IAM role ARN."
  }
}

variable "scalable_dimension" {
  description = "Scalable dimension of the scalable target."
  type        = string

  validation {
    condition = contains([
      "ecs:service:DesiredCount",
      "ec2:spot-fleet-request:TargetCapacity",
      "elasticmapreduce:instancegroup:InstanceCount",
      "appstream:fleet:DesiredCapacity",
      "dynamodb:table:ReadCapacityUnits",
      "dynamodb:table:WriteCapacityUnits",
      "dynamodb:index:ReadCapacityUnits",
      "dynamodb:index:WriteCapacityUnits",
      "rds:cluster:ReadReplicaCount",
      "sagemaker:variant:DesiredInstanceCount",
      "custom-resource:CustomScalable",
      "comprehend:document-classifier-endpoint:DesiredInferenceUnits",
      "comprehend:entity-recognizer-endpoint:DesiredInferenceUnits",
      "lambda:function:ProvisionedConcurrencyUtilization",
      "cassandra:table:ReadCapacityUnits",
      "cassandra:table:WriteCapacityUnits",
      "kafka:broker-storage:VolumeSize",
      "elasticache:replication-group:NodeGroups",
      "elasticache:replication-group:Replicas",
      "neptune:cluster:ReadReplicaCount",
      "mq:broker:StorageSize"
    ], var.scalable_dimension)
    error_message = "resource_aws_appautoscaling_target, scalable_dimension must be a valid scalable dimension."
  }
}

variable "service_namespace" {
  description = "AWS service namespace of the scalable target."
  type        = string

  validation {
    condition = contains([
      "ecs",
      "elasticmapreduce",
      "ec2",
      "appstream",
      "dynamodb",
      "rds",
      "sagemaker",
      "custom-resource",
      "comprehend",
      "lambda",
      "cassandra",
      "kafka",
      "elasticache",
      "neptune",
      "mq"
    ], var.service_namespace)
    error_message = "resource_aws_appautoscaling_target, service_namespace must be a valid service namespace."
  }
}

variable "suspended_state" {
  description = "Specifies whether the scaling activities for a scalable target are in a suspended state."
  type = object({
    dynamic_scaling_in_suspended  = optional(bool, false)
    dynamic_scaling_out_suspended = optional(bool, false)
    scheduled_scaling_suspended   = optional(bool, false)
  })
  default = null
}

variable "tags" {
  description = "Map of tags to assign to the scalable target."
  type        = map(string)
  default     = {}
}