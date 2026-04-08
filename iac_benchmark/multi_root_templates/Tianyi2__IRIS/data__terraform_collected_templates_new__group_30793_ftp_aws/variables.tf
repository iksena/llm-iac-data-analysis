variable "subnet_id" {}
variable "bastion_ip" {}
variable "security_group_ids" { type    = list(string) }

variable "ftp_username" {
  default = 'ftpuser'
}
variable "ftp_password" {
  default = 'ftppassword'
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
  default = "15"
}

variable "instance_type" {
  default = "t3a.medium"
}

