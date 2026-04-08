variable "vpc_cidr" {
  default     = "172.17.0.0/16"
  description = "VPC IP range in CIDR notation (including mask)"
}

variable "default_tag" {
  type    = string
  default = "project-assignment"
}

variable "cluster_name" {
  type    = string
  default = "eks"
}