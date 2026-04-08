# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "test-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["${var.region}a", "${var.region}b"]
#   private_subnets = []
#   public_subnets  = ["10.0.10.0/24", "10.0.20.0/24"]

#   enable_nat_gateway = false
#   enable_vpn_gateway = false

#   tags = {
#     Terraform = "true"
#   }
# }