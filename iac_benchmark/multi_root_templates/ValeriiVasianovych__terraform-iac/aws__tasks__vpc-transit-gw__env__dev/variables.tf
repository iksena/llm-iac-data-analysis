variable "region" {
  description = "The AWS region where the resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "The environment for the resources, e.g., dev, prod."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  default = {
    vpc1 = "10.10.0.0/16"
    vpc2 = "10.20.0.0/16"
    vpc3 = "10.30.0.0/16"
  }
  type = map(string)
}

locals {
  public_subnet_cidrs = {
    for k, v in var.vpc_cidr : k => cidrsubnet(v, 8, 10) # /16 → /24 (new bits = 8, subnet index = 10)
  }
}

locals {
  ec2_map = {
    for vpc_name, vpc_mod in module.vpc :
    vpc_name => {
      subnet_id = vpc_mod.public_subnets[0]
      sg_id     = aws_security_group.sg[vpc_name].id
    }
  }
}


locals {
  vpc_cidrs = var.vpc_cidr
}

variable "instance_type" {
  description = "The instance type for the EC2 instances."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
    type = string
    description = "The name of the key pair to use for the instance"
    default = "aws_ssh_key"
}
