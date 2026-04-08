variable "region" {
  default = "us-east-1"
}

variable "repo_name" {
  default = "<change-this-in-tfvars>"
}

variable "decrypt_allowed_users" {
  default = []
}

variable "encrypt_allowed_users" {
  default = []
}
