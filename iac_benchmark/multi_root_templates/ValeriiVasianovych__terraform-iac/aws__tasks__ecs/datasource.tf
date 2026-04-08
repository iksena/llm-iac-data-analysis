data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "subnets" {}