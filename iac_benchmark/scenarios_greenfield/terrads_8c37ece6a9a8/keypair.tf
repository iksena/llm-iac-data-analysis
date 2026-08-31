variable "ssh_keypair_name" {
  type = string
  description = "AWS SSH key pair name"
  default = "benchmark-keypair"
  validation {
    condition     = length(var.ssh_keypair_name) > 4
    error_message = "The SSH key pair name must be greater than 4 characters."
  }
}

variable "ssh_keypair_public_key_text" {
  type = string
  description = "AWS SSH key pair public key text"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVQ1f/KHG+c/iDC/dWn0Z92wZF6zHmweK9vabEXbgTO6CrgznyyTUxQkz2N8dCzY4AID04kj9OynfHortl53ftWQOkL+ARj4CQWONJdTHCFP+c3QWezxrnCRuo8JgIbyVXL22HCAuyMGfjDN9BbbrCW8O0HmPnfY/mJABprsoqWnqoIvdZNyjdWC/iT2nPF4ShwAd/Ji5eYpswCen2cRAmazTi7fpzEzbZJNLuHaN9ssWsQ9AvsESayurkGwtNXrdmtDXGo9XHmANhRc1SidnPA7/YYi/GinKDbB5s+fK8vRCuX0PxEj8yq4LlCr5CjW6hf2Gd4uafNMZ9bHyhd3Jv benchmark-generated"
  validation {
    condition     = length(var.ssh_keypair_public_key_text) > 0
    error_message = "The SSH key pair public key text must not be empty."
  }
}

resource "aws_key_pair" "deployment_keypair" {
  key_name   = var.ssh_keypair_name
  public_key = var.ssh_keypair_public_key_text
}

output "ssh_keypair" {
  value = {
    name = aws_key_pair.deployment_keypair.key_name
    public_key = var.ssh_keypair_public_key_text
    fingerprint = aws_key_pair.deployment_keypair.fingerprint
  }
  description = "Deployment SSH keypair"
}