data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.solution_short}-${var.env}-vpc"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.solution_short}-${var.env}-default"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  tags = {
    Name = "${var.solution_short}-${var.env}-default"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.solution_short}-${var.env}-igw"
  }
}

// VPC endpoints
resource "aws_vpc_endpoint" "private-s3" {
  vpc_id          = aws_vpc.vpc.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = concat(aws_route_table.private.*.id, [aws_route_table.public.id])

  tags = {
    Name = "${var.solution_short}-${var.env}-s3_vpc_endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private.*.id

  security_group_ids = [
    aws_security_group.InterfaceEndpoint.id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.solution_short}-${var.env}-ec2_vpc_endpoint"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private.*.id

  security_group_ids = [
    aws_security_group.InterfaceEndpoint.id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.solution_short}-${var.env}-ssm_vpc_endpoint"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private.*.id

  security_group_ids = [
    aws_security_group.InterfaceEndpoint.id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.solution_short}-${var.env}-ssmmessages_vpc_endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private.*.id

  security_group_ids = [
    aws_security_group.InterfaceEndpoint.id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.solution_short}-${var.env}-ec2messages_vpc_endpoint"
  }
}

resource "aws_vpc_endpoint" "kms" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.kms"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private.*.id

  security_group_ids = [
    aws_security_group.InterfaceEndpoint.id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.solution_short}-${var.env}-kms_vpc_endpoint"
  }
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.private.*.id

  security_group_ids = [
    aws_security_group.InterfaceEndpoint.id
  ]
  private_dns_enabled = true

  tags = {
    Name = "${var.solution_short}-${var.env}-logs_vpc_endpoint"
  }
}

resource "aws_flow_log" "flow" {
  log_destination      = aws_s3_bucket.access-logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id

  tags = {
    Name = "${var.solution_short}-${var.env}-flowlogs"
  }
}
