variable "name" {
  description = "Name of the filter"
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_inspector2_filter, name must be a non-empty string."
  }
}

variable "action" {
  description = "Action to be applied to the findings that match the filter"
  type        = string

  validation {
    condition     = contains(["NONE", "SUPPRESS"], var.action)
    error_message = "resource_aws_inspector2_filter, action must be either 'NONE' or 'SUPPRESS'."
  }
}

variable "description" {
  description = "Description of the filter"
  type        = string
  default     = null
}

variable "reason" {
  description = "Reason for creating the filter"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}
}

variable "filter_criteria_aws_account_id" {
  description = "The AWS account ID in which the finding was generated"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_aws_account_id == null || (
      var.filter_criteria_aws_account_id.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_aws_account_id.comparison) &&
      var.filter_criteria_aws_account_id.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_aws_account_id comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_code_repository_project_name" {
  description = "The project name in a code repository"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_code_repository_project_name == null || (
      var.filter_criteria_code_repository_project_name.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_code_repository_project_name.comparison) &&
      var.filter_criteria_code_repository_project_name.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_code_repository_project_name comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_code_repository_provider_type" {
  description = "The repository provider type (such as GitHub, GitLab, etc.)"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_code_repository_provider_type == null || (
      var.filter_criteria_code_repository_provider_type.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_code_repository_provider_type.comparison) &&
      var.filter_criteria_code_repository_provider_type.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_code_repository_provider_type comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_code_vulnerability_detector_name" {
  description = "The code vulnerability detector name"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_code_vulnerability_detector_name == null || (
      var.filter_criteria_code_vulnerability_detector_name.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_code_vulnerability_detector_name.comparison) &&
      var.filter_criteria_code_vulnerability_detector_name.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_code_vulnerability_detector_name comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_code_vulnerability_detector_tags" {
  description = "The code vulnerability detector tags"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_code_vulnerability_detector_tags == null || (
      var.filter_criteria_code_vulnerability_detector_tags.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_code_vulnerability_detector_tags.comparison) &&
      var.filter_criteria_code_vulnerability_detector_tags.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_code_vulnerability_detector_tags comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_code_vulnerability_file_path" {
  description = "The code vulnerability file path"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_code_vulnerability_file_path == null || (
      var.filter_criteria_code_vulnerability_file_path.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_code_vulnerability_file_path.comparison) &&
      var.filter_criteria_code_vulnerability_file_path.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_code_vulnerability_file_path comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_component_id" {
  description = "The ID of the component"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_component_id == null || (
      var.filter_criteria_component_id.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_component_id.comparison) &&
      var.filter_criteria_component_id.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_component_id comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_component_type" {
  description = "The type of the component"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_component_type == null || (
      var.filter_criteria_component_type.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_component_type.comparison) &&
      var.filter_criteria_component_type.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_component_type comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_ec2_instance_image_id" {
  description = "The ID of the Amazon Machine Image (AMI)"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_ec2_instance_image_id == null || (
      var.filter_criteria_ec2_instance_image_id.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_ec2_instance_image_id.comparison) &&
      var.filter_criteria_ec2_instance_image_id.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ec2_instance_image_id comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_ec2_instance_subnet_id" {
  description = "The ID of the subnet"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_ec2_instance_subnet_id == null || (
      var.filter_criteria_ec2_instance_subnet_id.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_ec2_instance_subnet_id.comparison) &&
      var.filter_criteria_ec2_instance_subnet_id.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ec2_instance_subnet_id comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_ec2_instance_vpc_id" {
  description = "The ID of the VPC"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_ec2_instance_vpc_id == null || (
      var.filter_criteria_ec2_instance_vpc_id.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_ec2_instance_vpc_id.comparison) &&
      var.filter_criteria_ec2_instance_vpc_id.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ec2_instance_vpc_id comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_ecr_image_architecture" {
  description = "The architecture of the ECR image"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_ecr_image_architecture == null || (
      var.filter_criteria_ecr_image_architecture.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_ecr_image_architecture.comparison) &&
      var.filter_criteria_ecr_image_architecture.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ecr_image_architecture comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_ecr_image_in_use_count" {
  description = "The number of the ECR images in use"
  type = object({
    lower_inclusive = optional(number)
    upper_inclusive = optional(number)
  })
  default = null

  validation {
    condition = var.filter_criteria_ecr_image_in_use_count == null || (
      var.filter_criteria_ecr_image_in_use_count.lower_inclusive != null ||
      var.filter_criteria_ecr_image_in_use_count.upper_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ecr_image_in_use_count must specify at least one of lower_inclusive or upper_inclusive."
  }
}

variable "filter_criteria_ecr_image_last_in_use_at" {
  description = "The date range when an ECR image was last used in an ECS cluster task or EKS cluster pod"
  type = object({
    start_inclusive = optional(string)
    end_inclusive   = optional(string)
  })
  default = null

  validation {
    condition = var.filter_criteria_ecr_image_last_in_use_at == null || (
      var.filter_criteria_ecr_image_last_in_use_at.start_inclusive != null ||
      var.filter_criteria_ecr_image_last_in_use_at.end_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ecr_image_last_in_use_at must specify at least one of start_inclusive or end_inclusive."
  }
}

variable "filter_criteria_ecr_image_hash" {
  description = "The SHA256 hash of the ECR image"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_ecr_image_hash == null || (
      var.filter_criteria_ecr_image_hash.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_ecr_image_hash.comparison) &&
      var.filter_criteria_ecr_image_hash.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ecr_image_hash comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_ecr_image_pushed_at" {
  description = "The date range when the image was pushed"
  type = object({
    start_inclusive = optional(string)
    end_inclusive   = optional(string)
  })
  default = null

  validation {
    condition = var.filter_criteria_ecr_image_pushed_at == null || (
      var.filter_criteria_ecr_image_pushed_at.start_inclusive != null ||
      var.filter_criteria_ecr_image_pushed_at.end_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ecr_image_pushed_at must specify at least one of start_inclusive or end_inclusive."
  }
}

variable "filter_criteria_ecr_image_registry" {
  description = "The registry of the ECR image"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_ecr_image_registry == null || (
      var.filter_criteria_ecr_image_registry.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_ecr_image_registry.comparison) &&
      var.filter_criteria_ecr_image_registry.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ecr_image_registry comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_ecr_image_repository_name" {
  description = "The name of the ECR repository"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_ecr_image_repository_name == null || (
      var.filter_criteria_ecr_image_repository_name.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_ecr_image_repository_name.comparison) &&
      var.filter_criteria_ecr_image_repository_name.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ecr_image_repository_name comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_ecr_image_tags" {
  description = "The tags associated with the ECR image"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_ecr_image_tags == null || (
      var.filter_criteria_ecr_image_tags.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_ecr_image_tags.comparison) &&
      var.filter_criteria_ecr_image_tags.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_ecr_image_tags comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_epss_score" {
  description = "EPSS (Exploit Prediction Scoring System) Score of the finding"
  type = object({
    lower_inclusive = optional(number)
    upper_inclusive = optional(number)
  })
  default = null

  validation {
    condition = var.filter_criteria_epss_score == null || (
      var.filter_criteria_epss_score.lower_inclusive != null ||
      var.filter_criteria_epss_score.upper_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_epss_score must specify at least one of lower_inclusive or upper_inclusive."
  }
}

variable "filter_criteria_exploit_available" {
  description = "Availability of exploits"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_exploit_available == null || (
      var.filter_criteria_exploit_available.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_exploit_available.comparison) &&
      var.filter_criteria_exploit_available.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_exploit_available comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_finding_arn" {
  description = "The ARN of the finding"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_finding_arn == null || (
      var.filter_criteria_finding_arn.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_finding_arn.comparison) &&
      var.filter_criteria_finding_arn.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_finding_arn comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_finding_status" {
  description = "The status of the finding"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_finding_status == null || (
      var.filter_criteria_finding_status.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_finding_status.comparison) &&
      var.filter_criteria_finding_status.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_finding_status comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_finding_type" {
  description = "The type of the finding"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_finding_type == null || (
      var.filter_criteria_finding_type.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_finding_type.comparison) &&
      var.filter_criteria_finding_type.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_finding_type comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_fix_available" {
  description = "Availability of the fix"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_fix_available == null || (
      var.filter_criteria_fix_available.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_fix_available.comparison) &&
      var.filter_criteria_fix_available.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_fix_available comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_first_observed_at" {
  description = "When the finding was first observed"
  type = object({
    start_inclusive = optional(string)
    end_inclusive   = optional(string)
  })
  default = null

  validation {
    condition = var.filter_criteria_first_observed_at == null || (
      var.filter_criteria_first_observed_at.start_inclusive != null ||
      var.filter_criteria_first_observed_at.end_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_first_observed_at must specify at least one of start_inclusive or end_inclusive."
  }
}

variable "filter_criteria_inspector_score" {
  description = "The Inspector score given to the finding"
  type = object({
    lower_inclusive = optional(number)
    upper_inclusive = optional(number)
  })
  default = null

  validation {
    condition = var.filter_criteria_inspector_score == null || (
      var.filter_criteria_inspector_score.lower_inclusive != null ||
      var.filter_criteria_inspector_score.upper_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_inspector_score must specify at least one of lower_inclusive or upper_inclusive."
  }
}

variable "filter_criteria_lambda_function_execution_role_arn" {
  description = "Lambda execution role ARN"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_lambda_function_execution_role_arn == null || (
      var.filter_criteria_lambda_function_execution_role_arn.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_lambda_function_execution_role_arn.comparison) &&
      var.filter_criteria_lambda_function_execution_role_arn.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_lambda_function_execution_role_arn comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_lambda_function_last_modified_at" {
  description = "Last modified timestamp of the lambda function"
  type = object({
    start_inclusive = optional(string)
    end_inclusive   = optional(string)
  })
  default = null

  validation {
    condition = var.filter_criteria_lambda_function_last_modified_at == null || (
      var.filter_criteria_lambda_function_last_modified_at.start_inclusive != null ||
      var.filter_criteria_lambda_function_last_modified_at.end_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_lambda_function_last_modified_at must specify at least one of start_inclusive or end_inclusive."
  }
}

variable "filter_criteria_lambda_function_layers" {
  description = "Lambda function layers"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_lambda_function_layers == null || (
      var.filter_criteria_lambda_function_layers.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_lambda_function_layers.comparison) &&
      var.filter_criteria_lambda_function_layers.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_lambda_function_layers comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_lambda_function_name" {
  description = "Lambda function name"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_lambda_function_name == null || (
      var.filter_criteria_lambda_function_name.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_lambda_function_name.comparison) &&
      var.filter_criteria_lambda_function_name.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_lambda_function_name comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_lambda_function_runtime" {
  description = "Lambda function runtime"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_lambda_function_runtime == null || (
      var.filter_criteria_lambda_function_runtime.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_lambda_function_runtime.comparison) &&
      var.filter_criteria_lambda_function_runtime.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_lambda_function_runtime comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_last_observed_at" {
  description = "When the finding was last observed"
  type = object({
    start_inclusive = optional(string)
    end_inclusive   = optional(string)
  })
  default = null

  validation {
    condition = var.filter_criteria_last_observed_at == null || (
      var.filter_criteria_last_observed_at.start_inclusive != null ||
      var.filter_criteria_last_observed_at.end_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_last_observed_at must specify at least one of start_inclusive or end_inclusive."
  }
}

variable "filter_criteria_network_protocol" {
  description = "The network protocol of the finding"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_network_protocol == null || (
      var.filter_criteria_network_protocol.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_network_protocol.comparison) &&
      var.filter_criteria_network_protocol.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_network_protocol comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_port_range" {
  description = "The port range of the finding"
  type = object({
    begin_inclusive = number
    end_inclusive   = number
  })
  default = null

  validation {
    condition = var.filter_criteria_port_range == null || (
      var.filter_criteria_port_range.begin_inclusive != null &&
      var.filter_criteria_port_range.end_inclusive != null &&
      var.filter_criteria_port_range.begin_inclusive <= var.filter_criteria_port_range.end_inclusive
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_port_range must specify both begin_inclusive and end_inclusive, with begin_inclusive <= end_inclusive."
  }
}

variable "filter_criteria_related_vulnerabilities" {
  description = "Related vulnerabilities"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_related_vulnerabilities == null || (
      var.filter_criteria_related_vulnerabilities.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_related_vulnerabilities.comparison) &&
      var.filter_criteria_related_vulnerabilities.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_related_vulnerabilities comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_resource_id" {
  description = "The ID of the resource"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_resource_id == null || (
      var.filter_criteria_resource_id.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_resource_id.comparison) &&
      var.filter_criteria_resource_id.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_resource_id comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_resource_tags" {
  description = "The tags of the resource"
  type = object({
    comparison = string
    key        = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_resource_tags == null || (
      var.filter_criteria_resource_tags.comparison != null &&
      contains(["EQUALS"], var.filter_criteria_resource_tags.comparison) &&
      var.filter_criteria_resource_tags.key != null &&
      var.filter_criteria_resource_tags.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_resource_tags comparison must be 'EQUALS' and key, value must be provided."
  }
}

variable "filter_criteria_resource_type" {
  description = "The type of the resource"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_resource_type == null || (
      var.filter_criteria_resource_type.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_resource_type.comparison) &&
      var.filter_criteria_resource_type.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_resource_type comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_severity" {
  description = "The severity of the finding"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_severity == null || (
      var.filter_criteria_severity.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_severity.comparison) &&
      var.filter_criteria_severity.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_severity comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_title" {
  description = "The title of the finding"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_title == null || (
      var.filter_criteria_title.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_title.comparison) &&
      var.filter_criteria_title.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_title comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_updated_at" {
  description = "When the finding was last updated"
  type = object({
    start_inclusive = optional(string)
    end_inclusive   = optional(string)
  })
  default = null

  validation {
    condition = var.filter_criteria_updated_at == null || (
      var.filter_criteria_updated_at.start_inclusive != null ||
      var.filter_criteria_updated_at.end_inclusive != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_updated_at must specify at least one of start_inclusive or end_inclusive."
  }
}

variable "filter_criteria_vendor_severity" {
  description = "The severity as reported by the vendor"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_vendor_severity == null || (
      var.filter_criteria_vendor_severity.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vendor_severity.comparison) &&
      var.filter_criteria_vendor_severity.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_vendor_severity comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_vulnerability_id" {
  description = "The ID of the vulnerability"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_vulnerability_id == null || (
      var.filter_criteria_vulnerability_id.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerability_id.comparison) &&
      var.filter_criteria_vulnerability_id.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_vulnerability_id comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_vulnerability_source" {
  description = "The source of the vulnerability"
  type = object({
    comparison = string
    value      = string
  })
  default = null

  validation {
    condition = var.filter_criteria_vulnerability_source == null || (
      var.filter_criteria_vulnerability_source.comparison != null &&
      contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerability_source.comparison) &&
      var.filter_criteria_vulnerability_source.value != null
    )
    error_message = "resource_aws_inspector2_filter, filter_criteria_vulnerability_source comparison must be one of 'EQUALS', 'PREFIX', 'NOT_EQUALS' and value must be provided."
  }
}

variable "filter_criteria_vulnerable_packages" {
  description = "Details about vulnerable packages"
  type = object({
    architecture = optional(object({
      comparison = string
      value      = string
    }))
    epoch = optional(object({
      lower_inclusive = optional(number)
      upper_inclusive = optional(number)
    }))
    file_path = optional(object({
      comparison = string
      value      = string
    }))
    name = optional(object({
      comparison = string
      value      = string
    }))
    release = optional(object({
      comparison = string
      value      = string
    }))
    source_lambda_layer_arn = optional(object({
      comparison = string
      value      = string
    }))
    source_layer_hash = optional(object({
      comparison = string
      value      = string
    }))
    version = optional(object({
      comparison = string
      value      = string
    }))
  })
  default = null

  validation {
    condition = var.filter_criteria_vulnerable_packages == null || alltrue([
      var.filter_criteria_vulnerable_packages.architecture == null || (
        var.filter_criteria_vulnerable_packages.architecture.comparison != null &&
        contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerable_packages.architecture.comparison) &&
        var.filter_criteria_vulnerable_packages.architecture.value != null
      ),
      var.filter_criteria_vulnerable_packages.epoch == null || (
        var.filter_criteria_vulnerable_packages.epoch.lower_inclusive != null ||
        var.filter_criteria_vulnerable_packages.epoch.upper_inclusive != null
      ),
      var.filter_criteria_vulnerable_packages.file_path == null || (
        var.filter_criteria_vulnerable_packages.file_path.comparison != null &&
        contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerable_packages.file_path.comparison) &&
        var.filter_criteria_vulnerable_packages.file_path.value != null
      ),
      var.filter_criteria_vulnerable_packages.name == null || (
        var.filter_criteria_vulnerable_packages.name.comparison != null &&
        contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerable_packages.name.comparison) &&
        var.filter_criteria_vulnerable_packages.name.value != null
      ),
      var.filter_criteria_vulnerable_packages.release == null || (
        var.filter_criteria_vulnerable_packages.release.comparison != null &&
        contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerable_packages.release.comparison) &&
        var.filter_criteria_vulnerable_packages.release.value != null
      ),
      var.filter_criteria_vulnerable_packages.source_lambda_layer_arn == null || (
        var.filter_criteria_vulnerable_packages.source_lambda_layer_arn.comparison != null &&
        contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerable_packages.source_lambda_layer_arn.comparison) &&
        var.filter_criteria_vulnerable_packages.source_lambda_layer_arn.value != null
      ),
      var.filter_criteria_vulnerable_packages.source_layer_hash == null || (
        var.filter_criteria_vulnerable_packages.source_layer_hash.comparison != null &&
        contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerable_packages.source_layer_hash.comparison) &&
        var.filter_criteria_vulnerable_packages.source_layer_hash.value != null
      ),
      var.filter_criteria_vulnerable_packages.version == null || (
        var.filter_criteria_vulnerable_packages.version.comparison != null &&
        contains(["EQUALS", "PREFIX", "NOT_EQUALS"], var.filter_criteria_vulnerable_packages.version.comparison) &&
        var.filter_criteria_vulnerable_packages.version.value != null
      )
    ])
    error_message = "resource_aws_inspector2_filter, filter_criteria_vulnerable_packages validation failed: string filters must have valid comparison operators ('EQUALS', 'PREFIX', 'NOT_EQUALS') and values; number filters must specify at least one bound."
  }
}