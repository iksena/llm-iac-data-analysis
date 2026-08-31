resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = aws_subnet.public[*].id

  ingress {
    protocol   = 6
    rule_no    = 90
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = 6
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = 6
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = 6
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = 6
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    protocol   = 6
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "${var.solution_short}-${var.env}-vpc_nacl_public"
  }
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = aws_subnet.private[*].id

  ingress {
    protocol = 6
    rule_no  = 100
    action   = "allow"
    #cidr_block = "0.0.0.0/0"
    cidr_block = var.vpc_cidr_block
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = 6
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    #cidr_block = var.vpc_cidr_block
    from_port = 443
    to_port   = 443
  }

  ingress {
    protocol = 6
    rule_no  = 120
    action   = "allow"
    #cidr_block = "0.0.0.0/0"
    cidr_block = var.vpc_cidr_block
    from_port  = 5432
    to_port    = 5432
  }

  ingress {
    protocol   = 6
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    #cidr_block = var.vpc_cidr_block
    from_port = 1024
    to_port   = 65535
  }

  egress {
    protocol   = 6
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    #cidr_block = var.vpc_cidr_block
    from_port = 1024
    to_port   = 65535
  }

  egress {
    protocol   = 6
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    #cidr_block = var.vpc_cidr_block
    from_port = 443
    to_port   = 443
  }

  egress {
    protocol   = 6
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    #cidr_block = var.vpc_cidr_block
    from_port = 80
    to_port   = 80
  }

  egress {
    protocol = 6
    rule_no  = 130
    action   = "allow"
    #cidr_block = "0.0.0.0/0"
    cidr_block = var.vpc_cidr_block
    from_port  = 5432
    to_port    = 5432
  }

  tags = {
    Name = "${var.solution_short}-${var.env}-vpc_nacl_private"
  }
}
