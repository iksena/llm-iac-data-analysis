resource "aws_vpc" "vpc" {
  count = var.environment == "prod" ? 1 : 0
  // export TF_VAR_environment=developer
  // export TF_VAR_environment=prod

  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "vpc-terraform"
  }
}
