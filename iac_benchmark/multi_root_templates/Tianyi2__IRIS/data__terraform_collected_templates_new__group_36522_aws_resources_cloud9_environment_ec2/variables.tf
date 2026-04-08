variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the environment."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloud9_environment_ec2, name must not be empty."
  }
}

variable "instance_type" {
  description = "The type of instance to connect to the environment, e.g., t2.micro."
  type        = string

  validation {
    condition     = length(var.instance_type) > 0
    error_message = "resource_aws_cloud9_environment_ec2, instance_type must not be empty."
  }
}

variable "image_id" {
  description = "The identifier for the Amazon Machine Image (AMI) that's used to create the EC2 instance."
  type        = string

  validation {
    condition = contains([
      "amazonlinux-2-x86_64",
      "amazonlinux-2023-x86_64",
      "ubuntu-18.04-x86_64",
      "ubuntu-22.04-x86_64",
      "resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2-x86_64",
      "resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2023-x86_64",
      "resolve:ssm:/aws/service/cloud9/amis/ubuntu-18.04-x86_64",
      "resolve:ssm:/aws/service/cloud9/amis/ubuntu-22.04-x86_64"
    ], var.image_id)
    error_message = "resource_aws_cloud9_environment_ec2, image_id must be one of: amazonlinux-2-x86_64, amazonlinux-2023-x86_64, ubuntu-18.04-x86_64, ubuntu-22.04-x86_64, resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2-x86_64, resolve:ssm:/aws/service/cloud9/amis/amazonlinux-2023-x86_64, resolve:ssm:/aws/service/cloud9/amis/ubuntu-18.04-x86_64, resolve:ssm:/aws/service/cloud9/amis/ubuntu-22.04-x86_64."
  }
}

variable "automatic_stop_time_minutes" {
  description = "The number of minutes until the running instance is shut down after the environment has last been used."
  type        = number
  default     = null

  validation {
    condition     = var.automatic_stop_time_minutes == null || var.automatic_stop_time_minutes > 0
    error_message = "resource_aws_cloud9_environment_ec2, automatic_stop_time_minutes must be greater than 0 when specified."
  }
}

variable "connection_type" {
  description = "The connection type used for connecting to an Amazon EC2 environment."
  type        = string
  default     = null

  validation {
    condition     = var.connection_type == null || contains(["CONNECT_SSH", "CONNECT_SSM"], var.connection_type)
    error_message = "resource_aws_cloud9_environment_ec2, connection_type must be either CONNECT_SSH or CONNECT_SSM."
  }
}

variable "description" {
  description = "The description of the environment."
  type        = string
  default     = null
}

variable "owner_arn" {
  description = "The ARN of the environment owner. This can be ARN of any AWS IAM principal. Defaults to the environment's creator."
  type        = string
  default     = null

  validation {
    condition     = var.owner_arn == null || can(regex("^arn:aws", var.owner_arn))
    error_message = "resource_aws_cloud9_environment_ec2, owner_arn must be a valid ARN starting with 'arn:aws'."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet in Amazon VPC that AWS Cloud9 will use to communicate with the Amazon EC2 instance."
  type        = string
  default     = null

  validation {
    condition     = var.subnet_id == null || can(regex("^subnet-", var.subnet_id))
    error_message = "resource_aws_cloud9_environment_ec2, subnet_id must be a valid subnet ID starting with 'subnet-'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}