variable "network_id" {}
variable "bastion_ip" {}
variable "flavor" {}
variable "image" {}

variable "ftp_username" {
  default = 'ftpuser'
}
variable "ftp_password" {
  default = 'ftppassword'
}

variable "private_key" {
  default = "~/.ssh/faas_ssh"
}

variable "env_name" {
  default = "serverless-env"
}



