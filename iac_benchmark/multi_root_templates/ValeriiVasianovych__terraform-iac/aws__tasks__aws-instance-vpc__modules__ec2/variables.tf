variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
}

variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}