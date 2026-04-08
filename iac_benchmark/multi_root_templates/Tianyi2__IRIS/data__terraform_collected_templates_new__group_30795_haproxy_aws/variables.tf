variable "subnet_id" {}
variable "bastion_ip" {}
variable "backend_ips" { type = list(string) }
variable "security_group_ids" { type    = list(string) }

variable "openfaas_backend_port" {
  default = 8080
}

variable "prometheus_backend_port" {
  default = 9000
}

variable "private_key" {
  default = "~/.ssh/faas_ssh"
}

variable "image_id" {
  default = "ami-0affd4508a5d2481b"
}

variable "env_name" {
  default = "serverless-env"
}

variable "volume_size" {
  default = "12"
}

variable "instance_type" {
  default = "t2.micro"
}

