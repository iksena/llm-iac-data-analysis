variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "benchmark"
}

variable "vpc_cidr_network_octets" {
  type        = string
  description = "CIDR network range for the VPC"
  default     = "10.0"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Standard tags to add to deployed resources"
}
