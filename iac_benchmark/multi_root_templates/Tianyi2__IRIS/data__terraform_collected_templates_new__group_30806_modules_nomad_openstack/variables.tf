variable "network_id" {}

variable worker_name {}

variable "agent_type" {}

variable "private_key" {}

variable "bastion_ip" {}

variable "security_group_ids" { type    = list(string) }

variable "consul_hosts" {
  default = []
}

variable "docker_username" {
  default = ""
}

variable "docker_password" {
  default = ""
}

variable "env_name" {
  default = "serverless-env"
}

variable "server_group" {
  default = "serverless-group"
}

variable "server_group_policies" {
  default = ["anti-affinity"]
}

variable worker_count {
  default = "1"
}

variable worker_flavor {
  default = "m1.medium"
}

variable worker_image {
  default = "CentOS-7_6-x86_64-GenericCloud"
}

variable worker_volume_size {
  default = "40"
}

variable "datacenter" {
  default = "dc1"
}

variable consul_version {
  type    = string
  default = "1.2.0"
}

variable nomad_version {
  type    = "string"
  default = "0.8.4"
}

variable "consul_size" {
  default = 1
}