variable "bootcamp_name" {
  description = "Name of the bootcamp that will use the resources"
  type        = string
  default     = "cyber"
}

variable "bootcamp_edition" {
  description = "Edition of the bootcamp that will use the resources"
  type        = number
  default     = 11
}

# VPC CIDR
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Number of NAT Gateways
variable "vpc_nat_gateways_number" {
  description = "Number of NAT Gateways for the VPC"
  type        = number
  default     = 1
}

# VPC private subnets CIDRs
variable "vpc_private_subnets" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# VPC public subnets CIDRs
variable "vpc_public_subnets" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24"]
}

# VPC AZs
variable "vpc_azs" {
  description = "List of AZs to use for VPC"
  type        = list(string)
  default     = ["us-east-1a"]
}

# EC2 number
variable "ec2_instances" {
  description = "List of EC2 instances to create"
  type        = list(string)
  default     = [""]
}

# EC2 instance type
variable "ec2_instance_type" {
  description = "EC2 instance type like t2.medium, t3.micro, etc"
  type        = string
  default     = "t3.micro"
}

# EC2 EBS size
variable "ec2_instance_size" {
  description = "EC2 instance EBS volume size"
  type        = number
  default     = 30
}

# EC2 Allow IP for ssh

variable "ec2_instance_allowed_ips_ssh" {
  description = "Allowed IPs to connect via SSH to EC2 instance"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}
