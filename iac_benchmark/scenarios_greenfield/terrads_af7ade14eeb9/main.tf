module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.0"

  ipv4_primary_cidr_block          = var.vpc_cidr_block
  assign_generated_ipv6_cidr_block = false
  default_security_group_deny_all  = true
  name                             = var.vpc_name
  dns_hostnames_enabled            = true

}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.1"

  availability_zones  = var.availability_zones
  vpc_id              = module.vpc.vpc_id
  igw_id              = [module.vpc.igw_id]
  ipv4_cidr_block     = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled = true

}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = concat(
    module.subnets.public_route_table_ids,
    module.subnets.private_route_table_ids,
    [module.vpc.vpc_default_route_table_id]
  )
}

resource "aws_vpc_endpoint" "dkr" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  security_group_ids  = [aws_security_group.endpoint_security_group.id]
  subnet_ids          = module.subnets.private_subnet_ids
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  security_group_ids  = [aws_security_group.endpoint_security_group.id]
  subnet_ids          = module.subnets.private_subnet_ids
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  security_group_ids  = [aws_security_group.endpoint_security_group.id]
  subnet_ids          = module.subnets.private_subnet_ids
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  security_group_ids  = [aws_security_group.endpoint_security_group.id]
  subnet_ids          = module.subnets.private_subnet_ids
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "kms" {
  vpc_id              = module.vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.kms"
  security_group_ids  = [aws_security_group.endpoint_security_group.id]
  subnet_ids          = module.subnets.private_subnet_ids
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
}
resource "aws_security_group" "endpoint_security_group" {
  name   = "vpc_endpoint_sg"
  vpc_id = module.vpc.vpc_id
}
resource "aws_security_group_rule" "vpc_endpoint_access_ingress" {
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  self              = true
  security_group_id = aws_security_group.endpoint_security_group.id
}

resource "aws_security_group_rule" "vpc_endpoint_access_egress" {
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "egress"
  self              = true
  security_group_id = aws_security_group.endpoint_security_group.id
}
