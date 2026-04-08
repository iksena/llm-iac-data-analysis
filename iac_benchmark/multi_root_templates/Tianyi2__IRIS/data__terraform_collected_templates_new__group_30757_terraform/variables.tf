variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zones" {
  description = "List of GCP zones for subnets"
  type        = list(string)
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "image_family" {
  description = "Image family for the VM"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the instance"
  type        = string
}


variable "environment" {
  description = "Environment name (staging/production)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "app_port" {
  description = "Application port"
  type        = number
}

variable "dns_zone_name" {
  description = "DNS zone name"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of instances in auto scaling group"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of instances in auto scaling group"
  type        = number
}
