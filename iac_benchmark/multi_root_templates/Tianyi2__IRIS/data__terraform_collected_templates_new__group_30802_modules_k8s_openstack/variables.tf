variable "network_id" {}

variable "private_key" {}

variable "bastion_ip" {}

variable "worker_name" {}

variable "docker_username" {}

variable "docker_password" {}

variable "docker_email" {}

variable "security_group_ids" { type    = list(string) }

variable "master_count" {
  default = 1
}

variable "worker_count" {
  default = 2
}

variable "server_group" {
  default = "serverless-group"
}

variable "server_group_policies" {
  default = ["anti-affinity"]
}

variable "env_name" {
  default = "serverless-env"
}

variable server_flavor {
  default = "m1.medium"
}

variable server_image {
  default = "CentOS-7_6-x86_64-GenericCloud"
}

