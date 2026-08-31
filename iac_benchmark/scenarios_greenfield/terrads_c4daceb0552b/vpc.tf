resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  instance_tenancy = var.tenancy
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6
  enable_dns_support = "${ var.enable_dns_support}"
  enable_dns_hostnames  = "${ var.enable_dns_hostnames}"
  tags = merge({
    Name = "${var.name}"
    },var.tags)
}


resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = merge({
    Name = "${var.name}_internet_gateway"
    },var.tags)
}
