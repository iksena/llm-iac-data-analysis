variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_elb_attachment, region must be a valid AWS region name or null."
  }
}

variable "elb" {
  type        = string
  description = "The name of the ELB."

  validation {
    condition     = can(regex("^.+$", var.elb))
    error_message = "resource_aws_elb_attachment, elb must be a non-empty string."
  }
}

variable "instance" {
  type        = string
  description = "Instance ID to place in the ELB pool."

  validation {
    condition     = can(regex("^i-[0-9a-f]+$", var.instance))
    error_message = "resource_aws_elb_attachment, instance must be a valid EC2 instance ID (format: i-xxxxxxxxxx)."
  }
}