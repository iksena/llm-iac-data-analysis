variable "network_id" {}
variable "bastion_ip" {}
variable "backend_ips" { type = list(string) }
variable "flavor" {}
variable "image" {}

variable "openfaas_backend_port" {
  default = 8080
}

variable "prometheus_backend_port" {
  default = 9000
}

variable "private_key" {
  default = "~/.ssh/faas_ssh"
}

variable "env_name" {
  default = "serverless-env"
}
