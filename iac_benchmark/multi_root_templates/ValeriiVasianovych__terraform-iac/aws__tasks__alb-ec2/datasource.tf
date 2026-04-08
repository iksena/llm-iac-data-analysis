data "aws_caller_identity" "current" {}
data "aws_subnets" "subnets" {}
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}
