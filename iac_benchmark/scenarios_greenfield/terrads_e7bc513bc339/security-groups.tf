resource "aws_security_group" "https_traffic" {
  name        = "http-traffic"
  description = "Allow http traffic (port 80)"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_ip_cidr_blocks_inbound
  }

  tags = var.tags
}

resource "aws_security_group" "ldap_traffic" {
  name        = "ldap-traffic"
  description = "Allow LDAP traffic (port 389)"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "LDAP"
    from_port   = 389
    to_port     = 389
    protocol    = "tcp"
    cidr_blocks = var.allowed_ldap_ip_cidr_blocks_inbound
  }

  tags = var.tags
}

resource "aws_security_group" "outbound_traffic" {
  name        = "outbound-traffic"
  description = "Allow outbound traffic"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "general outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_outbound_cidr_blocks
  }

  tags = var.tags
}
