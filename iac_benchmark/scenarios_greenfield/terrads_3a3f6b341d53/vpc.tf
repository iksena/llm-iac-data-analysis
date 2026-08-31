resource "aws_vpc" "main" {
  cidr_block         = var.vpc_config.cidr
  enable_dns_support = true
  tags = {
    Name = "${var.project_prefix}-${var.env}"
  }
}

resource "aws_subnet" "public" {
  for_each          = { for subnet in var.vpc_config.subnets.public : subnet.az => subnet }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.key
  tags = {
    Name = "${var.project_prefix}-public-${split("-", each.key)[2]}-${var.env}"
  }
}

resource "aws_subnet" "outerprivate" {
  for_each          = { for subnet in var.vpc_config.subnets.outerprivate : subnet.az => subnet }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.key
  tags = {
    Name = "${var.project_prefix}-outerprivate-${split("-", each.key)[2]}-${var.env}"
  }
}

resource "aws_subnet" "innerprivate" {
  for_each          = { for subnet in var.vpc_config.subnets.innerprivate : subnet.az => subnet }
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.key
  tags = {
    Name = "${var.project_prefix}-innerprivate-${split("-", each.key)[2]}-${var.env}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_prefix}-public-rt-${var.env}"
  }
}

resource "aws_route_table" "outerprivate" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_prefix}-outerprivate-rt-${var.env}"
  }
}

resource "aws_route_table" "innerprivate" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_prefix}-innerprivate-rt-${var.env}"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "outerprivate" {
  for_each       = aws_subnet.outerprivate
  subnet_id      = each.value.id
  route_table_id = aws_route_table.outerprivate.id
}

resource "aws_route_table_association" "innerprivate" {
  for_each       = aws_subnet.innerprivate
  subnet_id      = each.value.id
  route_table_id = aws_route_table.innerprivate.id
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_network_acl_rule" "default_ingress" {
  for_each = { for port in var.vpc_config.network_acls_ports.ingress : port => port }

  network_acl_id = aws_network_acl.main.id
  protocol       = "tcp"
  rule_number    = (index(var.vpc_config.network_acls_ports.ingress, each.value) + 1) * 100
  egress         = false
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = each.value
  to_port        = each.value
}

resource "aws_network_acl_rule" "default_egress" {
  for_each = { for port in var.vpc_config.network_acls_ports.egress : port => port }

  network_acl_id = aws_network_acl.main.id
  protocol       = "tcp"
  rule_number    = (index(var.vpc_config.network_acls_ports.egress, each.value) + 1) * 100
  egress         = true
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = each.value
  to_port        = each.value
}

resource "aws_network_acl_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "outerprivate" {
  for_each       = aws_subnet.outerprivate
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "innerprivate" {
  for_each       = aws_subnet.innerprivate
  subnet_id      = each.value.id
  network_acl_id = aws_network_acl.main.id
}