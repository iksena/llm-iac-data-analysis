variable "subnet_id" {}

variable "bastion_ip" {}

variable "security_group_ids" { type    = list(string) }

variable "docker_username" {}

variable "docker_password" {}

variable "private_key" {
  default = "~/.ssh/faas_ssh"
}

variable worker_name {
  default = "nomad"
}

variable "env_name" {
  default = "serverless-env"
}

variable "volume_size" {
  default = "15"
}

variable "instance_type" {
  default = "t3a.large"
}

variable "image_id" {
  default = "ami-0affd4508a5d2481b"
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