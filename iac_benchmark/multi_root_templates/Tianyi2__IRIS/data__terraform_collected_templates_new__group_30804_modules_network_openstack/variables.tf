variable "env_name" {
  default = "serverless-env"
}

variable "external_network_name" {
}

variable "subnet_cidr" {
  default = "192.168.0.0/24"
}

variable "dns_nameservers" {
  description = "An array of DNS name server names used by hosts in this subnet."
  type        = "list"
  default     = ["8.8.8.8", "8.8.4.4"]
}
