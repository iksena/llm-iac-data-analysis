data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpc" "my_vpc" {
  tags = {
    Name = "my_vpc"
  }
}