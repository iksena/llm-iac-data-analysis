variable "subnet_id" {}

variable "private_key" {}

variable "bastion_ip" {}

variable "worker_name" {}

variable "docker_username" {}

variable "docker_password" {}

variable "security_group_ids" { type    = list(string) }

variable "env_name" {
  default = "serverless-env"
}

variable "manager_count" {
  default = 1
}

variable "worker_count" {
  default = 2
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

