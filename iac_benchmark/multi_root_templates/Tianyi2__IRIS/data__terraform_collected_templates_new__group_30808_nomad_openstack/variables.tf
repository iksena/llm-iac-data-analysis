variable "bastion_ip" {}

variable "network_id" {}

variable "docker_username" {}

variable "docker_password" {}

variable "flavor" {}

variable "image" {}

variable worker_name {
  default = "nomad"
}

variable "private_key" {
  default = "~/.ssh/faas_ssh"
}

variable "env_name" {
  default = "serverless-env"
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

variable "servers_count" {
  default = 1
}

variable "clients_count" {
  default = 2
}
