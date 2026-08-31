locals {
  ssh_port       = 22
  http_port      = 80
  https_port     = 443
  redis_port     = 6379
  webserver_port = 8000
  anywhere       = ["0.0.0.0/0"]
}

variable "region" {
  description = "region"
  default     = "us-east-1"
}

variable "env" {
  description = "environment"
  default     = "benchmark"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  default     = "10.0.0.0/16"
}

variable "subnet_public_lb_a" {
  description = "public ALB subnet A"
  default     = "10.0.0.0/24"
}

variable "subnet_public_lb_b" {
  description = "public ALB subnet B"
  default     = "10.0.1.0/24"
}

variable "subnet_public_nat_a" {
  description = "public NAT GW subnet A"
  default     = "10.0.2.0/24"
}

variable "subnet_public_nat_b" {
  description = "public NAT GW subnet B"
  default     = "10.0.3.0/24"
}

variable "subnet_public_bastion_a" {
  description = "public bastion subnet A"
  default     = "10.0.4.0/24"
}

variable "subnet_public_bastion_b" {
  description = "public bastion subnet B"
  default     = "10.0.5.0/24"
}

variable "subnet_private_web_a" {
  description = "private web subnet A"
  default     = "10.0.6.0/24"
}

variable "subnet_private_web_b" {
  description = "private web subnet B"
  default     = "10.0.7.0/24"
}

variable "subnet_private_redis_a" {
  description = "private redis subnet A"
  default     = "10.0.8.0/24"
}

variable "subnet_private_redis_b" {
  description = "private redis subnet B"
  default     = "10.0.9.0/24"
}

variable "cidr_allowed_ssh" {
  description = "cidr block allowed to connect through SSH"
  default     = "10.0.0.0/16"
}

variable "ssh_public_key" {
  description = "ssh public key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBenchmarkDummyKeyDoNotUseInProduction0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 benchmark@example.com"
}
