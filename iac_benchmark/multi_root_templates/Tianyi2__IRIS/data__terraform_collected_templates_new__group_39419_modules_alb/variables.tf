# modules/alb/variables.tf
# Save this file as: modules/alb/variables.tf

variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB (must be in different AZs)"
  type        = list(string)
  
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "ALB requires at least 2 subnets in different availability zones."
  }
}

variable "security_group_id" {
  description = "Security group ID to attach to ALB"
  type        = string
}

variable "instance_ids" {
  description = "List of EC2 instance IDs to register with target group"
  type        = list(string)
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}
