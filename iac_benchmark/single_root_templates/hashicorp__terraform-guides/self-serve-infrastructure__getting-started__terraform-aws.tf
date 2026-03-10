# ── main.tf ────────────────────────────────────
provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "fp_demo_vpc"
  }
}

resource "aws_subnet" "demo_subnet" {
  vpc_id            = "${aws_vpc.demo_vpc.id}"
  cidr_block        = "${var.subnet_cidr_block}"
  availability_zone = "${var.subnet_availability_zone}"

  tags {
    Name = "fp_demo_subnet"
  }
}


# ── outputs.tf ────────────────────────────────────
output "vpc_id_consumable" {
  value       = "${aws_vpc.demo_vpc.id}"
  description = "This is the VPC ID for later use"
}

output "demo_subnet_id" {
  value       = "${aws_subnet.demo_subnet.id}"
  description = "This is the Subnet ID for later use"
}


# ── _interface.tf ────────────────────────────────────
variable "region" {
  default     = ""
  description = "The default AZ to provision to for the provider"
}

variable "vpc_cidr_block" {
  default     = ""
  description = "The default CIDR block for the VPC demo"
}

variable "subnet_cidr_block" {
  default     = ""
  description = "The default CIDR block for the subnet demo"
}

variable "subnet_availability_zone" {
  default     = ""
  description = "The default AZ for the subnet"
}
