#vpc.sprint0_vpc
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "enable_dns_host" {
  default     = true
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
}
variable "enable_dns_support" {
  default     = true
  description = "A boolean flag to enable/disable DNS support in the VPC"
}
variable "name_prefix" {
  description = "tag name"
  default     = "benchmark"
}
#eip.sprint0_eip
variable "eip_vpc" {
  default     = true
  description = "Boolean if the EIP is in a VPC or not"
}
#route_table.sprint0_public_rt
variable "rt_public_cidr" {
  default     = "0.0.0.0/0"
  description = "The CIDR block of the route"
}
#default_route_table.sprint0_private_rt
variable "rt_private_cidr" {
  default     = "0.0.0.0/0"
  description = "The CIDR block of the route"
}
#subnet.sprint0_public1_subnet
variable "cidrs" {
  type        = map(string)
  description = "Map of the CIDR blocks for the subnets"
  default = {
    public1  = "10.0.1.0/24"
    public2  = "10.0.2.0/24"
    private1 = "10.0.3.0/24"
    private2 = "10.0.4.0/24"
    rds1     = "10.0.5.0/24"
    rds2     = "10.0.6.0/24"
  }
}
variable "public_ip_map" {
  default     = true
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
}
#subnet.sprint0_private1_subnet
variable "private_ip_map" {
  default     = false
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
}
#subnet.sprint0_rds1_subnet
variable "rds_ip_map" {
  default     = false
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
}

data "aws_availability_zones" "available" {}