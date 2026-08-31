# Generics
variable "region" {
  description = "the region where the infrastructure will be hosted (us-east-2, us-east-1, etc)"
  default     = "us-east-1"
}

variable "env" {
  description = "the name of the environment we are managing (staging, rc, production)"
  default     = "dev"
}

variable "project" {
  description = "the name of the project"
  default     = "benchmark"
}

variable "create_prefix_for_resources" {
  description = "boolean variable to include the prefix '{var.project}_{var.env}' in all the resourse names."
  default     = true
}

# Networking
variable "vpc" {
  description = "the definition of the VPC"
  default     = [{ name = "vpc", cidr_block = "10.0.0.0/16", instance_tenancy = "default", enable_dns_hostnames = true, enable_dns_support = true }]
}

variable "subnet_public" {
  description = "the definition of the public subnet"
  default     = [{ name = "subnet_public", cidr_block = "10.0.1.0/24", availability_zone = "sa-east-1a", map_public_ip_on_launch = true }]
}

variable "security_group" {
  description = "security group definition"
  default     = [{ name = "security_group" }]
}

variable "route_table" {
  description = "route table definition"
  default     = [{ name = "route_table", cidr_block = "0.0.0.0/0", ipv6_cidr_block = "::/0" }]
}

variable "network_interface" {
  description = "network interface definition"
  default     = [{ name = "network_interface", private_ips = ["10.0.1.50"], device_index = 0 }]
}
