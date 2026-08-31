variable "environment" {
    type = string
    description = "Environment : dev, prod, stage etc"
  default     = "dev"
}
variable "project_name" {
      type = string
    description = "Project name"
  default     = "benchmark"
}
variable "vpc_cidr_block" {
    type = string
    description = "CIDR block for created VPC"
  default     = "10.0.0.0/16"
}
variable "vpc_instance_tenancy" {
    type = string
    description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}
variable "vpc_name" {
    type = string
    description = "VPC name"
  default     = "benchmark-vpc"
}
variable "vpc_enable_dns_support" {
  type = bool
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default     = true
}
variable "vpc_enable_dns_hostnames" {
  type = bool
  description = " A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = true
}
variable "internet_gateway_name" {
  type = string
  description = "Internet gateway for VPC for Internet access"
  default = "benchmark-igw"
}
variable "subnets_cidr_list" {
  type = list
  description = "List of CIDR's for creating subnets"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "availability_zones_list" {
    type = list
  description = "List of AZ in which subnets will be created"
  default = ["us-east-1a", "us-east-1b"]
}
variable "public_allowed_port_list_map" {
  type = map
  description = "Map of public allowed ports list to env "
  default = { dev = [80, 443] }
}
variable "admin_allowed_port_list_map" {
  type = map
  description = "Map of admin asscess allowed ports list to env "
  default = { dev = [22] }
}
variable "admin_ip_cidr" {
  type        = string
  description = "Admin IP adress for admin Sec group access restriction"
  default     = "10.0.0.0/16"
}