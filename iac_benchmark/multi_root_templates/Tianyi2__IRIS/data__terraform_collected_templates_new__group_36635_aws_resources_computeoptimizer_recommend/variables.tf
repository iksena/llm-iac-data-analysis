variable "resource_type" {
  description = "The target resource type of the recommendation preferences"
  type        = string

  validation {
    condition = contains([
      "Ec2Instance",
      "AutoScalingGroup",
      "RdsDBInstance",
      "AuroraDBClusterStorage"
    ], var.resource_type)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, resource_type must be one of: Ec2Instance, AutoScalingGroup, RdsDBInstance, AuroraDBClusterStorage."
  }
}

variable "scope" {
  description = "The scope of the recommendation preferences"
  type = object({
    name  = string
    value = string
  })

  validation {
    condition = contains([
      "Organization",
      "AccountId",
      "ResourceArn"
    ], var.scope.name)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, scope.name must be one of: Organization, AccountId, ResourceArn."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "enhanced_infrastructure_metrics" {
  description = "The status of the enhanced infrastructure metrics recommendation preference"
  type        = string
  default     = null

  validation {
    condition = var.enhanced_infrastructure_metrics == null || contains([
      "Active",
      "Inactive"
    ], var.enhanced_infrastructure_metrics)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, enhanced_infrastructure_metrics must be one of: Active, Inactive."
  }
}

variable "external_metrics_preference" {
  description = "The provider of the external metrics recommendation preference"
  type = object({
    source = string
  })
  default = null

  validation {
    condition = var.external_metrics_preference == null || contains([
      "Datadog",
      "Dynatrace",
      "NewRelic",
      "Instana"
    ], var.external_metrics_preference.source)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, external_metrics_preference.source must be one of: Datadog, Dynatrace, NewRelic, Instana."
  }
}

variable "inferred_workload_types" {
  description = "The status of the inferred workload types recommendation preference"
  type        = string
  default     = null

  validation {
    condition = var.inferred_workload_types == null || contains([
      "Active",
      "Inactive"
    ], var.inferred_workload_types)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, inferred_workload_types must be one of: Active, Inactive."
  }
}

variable "look_back_period" {
  description = "The preference to control the number of days the utilization metrics of the AWS resource are analyzed"
  type        = string
  default     = null

  validation {
    condition = var.look_back_period == null || contains([
      "DAYS_14",
      "DAYS_32",
      "DAYS_93"
    ], var.look_back_period)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, look_back_period must be one of: DAYS_14, DAYS_32, DAYS_93."
  }
}

variable "preferred_resource" {
  description = "The preference to control which resource type values are considered when generating rightsizing recommendations"
  type = object({
    name         = string
    exclude_list = optional(list(string))
    include_list = optional(list(string))
  })
  default = null

  validation {
    condition = var.preferred_resource == null || contains([
      "Ec2InstanceTypes"
    ], var.preferred_resource.name)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, preferred_resource.name must be one of: Ec2InstanceTypes."
  }

  validation {
    condition = var.preferred_resource == null || (
      var.preferred_resource.include_list != null || var.preferred_resource.exclude_list != null
    )
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, preferred_resource must specify either include_list or exclude_list."
  }
}

variable "savings_estimation_mode" {
  description = "The status of the savings estimation mode preference"
  type        = string
  default     = null

  validation {
    condition = var.savings_estimation_mode == null || contains([
      "AfterDiscounts",
      "BeforeDiscounts"
    ], var.savings_estimation_mode)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, savings_estimation_mode must be one of: AfterDiscounts, BeforeDiscounts."
  }
}

variable "utilization_preference" {
  description = "The preference to control the resource's CPU utilization threshold, CPU utilization headroom, and memory utilization headroom"
  type = object({
    metric_name = string
    metric_parameters = object({
      headroom  = string
      threshold = optional(string)
    })
  })
  default = null

  validation {
    condition = var.utilization_preference == null || contains([
      "CpuUtilization",
      "MemoryUtilization"
    ], var.utilization_preference.metric_name)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, utilization_preference.metric_name must be one of: CpuUtilization, MemoryUtilization."
  }

  validation {
    condition = var.utilization_preference == null || contains([
      "PERCENT_30",
      "PERCENT_20",
      "PERCENT_10",
      "PERCENT_0"
    ], var.utilization_preference.metric_parameters.headroom)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, utilization_preference.metric_parameters.headroom must be one of: PERCENT_30, PERCENT_20, PERCENT_10, PERCENT_0."
  }

  validation {
    condition = var.utilization_preference == null || var.utilization_preference.metric_parameters.threshold == null || contains([
      "P90",
      "P95",
      "P99_5"
    ], var.utilization_preference.metric_parameters.threshold)
    error_message = "resource_aws_computeoptimizer_recommendation_preferences, utilization_preference.metric_parameters.threshold must be one of: P90, P95, P99_5."
  }
}