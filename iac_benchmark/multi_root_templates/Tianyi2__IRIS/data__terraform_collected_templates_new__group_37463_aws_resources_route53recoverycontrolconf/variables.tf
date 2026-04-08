variable "cluster_arn" {
  description = "ARN of the cluster in which this control panel will reside."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:route53-recovery-control::", var.cluster_arn))
    error_message = "resource_aws_route53recoverycontrolconfig_control_panel, cluster_arn must be a valid Route53 Recovery Control cluster ARN starting with 'arn:aws:route53-recovery-control::'."
  }
}

variable "name" {
  description = "Name describing the control panel."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53recoverycontrolconfig_control_panel, name cannot be empty."
  }
}