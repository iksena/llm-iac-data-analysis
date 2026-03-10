# ── main.tf ────────────────────────────────────
resource "aws_vpc" "my_vpc" {
  cidr_block = var.network_config.vpc_cidr
  tags = {
    Name = var.network_config.vpc_name
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.network_config.subnet_cidr
  tags = {
    Name = var.network_config.subnet_name
  }
}


# ── variables.tf ────────────────────────────────────
variable "network_config" {
  type = object({
    vpc_name = string
    vpc_cidr = string
    subnet_name = string
    subnet_cidr = string
  })
}


# ── outputs.tf ────────────────────────────────────
output "vpc" {
  value = aws_vpc.my_vpc
}

output "subnet" {
  value = aws_subnet.my_subnet
}

output "subnet_id" {
  value = aws_subnet.my_subnet.id
}
