variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "flask-app-key"
}

variable "public_key" {
  description = "Public key content for SSH access"
  type        = string
}

variable "private_key" {
  description = "Private key content for SSH access"
  type        = string
  sensitive   = true
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}