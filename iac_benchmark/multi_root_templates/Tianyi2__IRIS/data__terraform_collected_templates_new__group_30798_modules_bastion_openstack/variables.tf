variable "external_network_name" {}

variable "network_id" {}

variable "public_key" {}

variable "private_key" {}

variable "env_name" {
  default = "serverless-env"
}

variable "allowed_cidr" {
  description = "A CIDR range of IP addresses which are allowed to SSH to the bastion host."
  default     = "0.0.0.0/0"
}

variable "flavor" {
  //default = "v2-highcpu-1"
  default = "s1-2"
}

variable "image" {
  //default = "CentOS 7.5.1804 (x86_64) [2018-06-06]"
  default = "Centos 7"
}
