#
# Variables Configuration
#

variable "customer_name" {
  description = "Customer name or cluster prefix"
  type    = string
  default = "benchmark"
}

variable "cluster_name" {
  description = "Cluster name or cluster suffix"
  type    = string
  default = "eks"
}

variable "cluster_version" {
  description = "Kubernetes version to deploy"
  default = "1.24"
  type    = string
}

variable "region" {
  description = "AWS region to launch servers"
  type    = string
  default = "us-east-1"
}

variable "instance_class" {
  description = "Machine type to be used"
  type    = string
  default = "t3.medium"
}

variable "autoscaling_options" {
  description = "Range for autoscaling of worker nodes"
  type        = map(string)
  default     = {
    desired_size = 2
    min_size = 2
    max_size = 4
  }
}

variable "public_subnet_cidr" {
  description = "CIDR of public subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidrs" {
  description = "CIDR of private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24","10.0.2.0/24"]
}