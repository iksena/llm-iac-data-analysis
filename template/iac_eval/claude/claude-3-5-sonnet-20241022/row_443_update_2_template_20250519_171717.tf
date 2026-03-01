provider "aws" {
  region = "us-west-2"
}

variable "vpc_id" {
  description = "The ID of the VPC to associate DHCP options with"
  type        = string
  default     = "vpc-12345678"
}

resource "aws_vpc_dhcp_options" "pike" {
  domain_name_servers = ["8.8.8.8", "8.8.4.4"]
  
  tags = {
    Name        = "pike"
    permissions = "true"
  }
}

resource "aws_vpc_dhcp_options_association" "pike_association" {
  vpc_id          = var.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.pike.id
}

output "dhcp_options_id" {
  value       = aws_vpc_dhcp_options.pike.id
  description = "The ID of the created DHCP Options Set"
}