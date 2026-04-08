resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = merge(var.common_tags, {
    Name = "VPC ${var.vpc_cidr}"
    })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name = "Public Subnet ${var.public_subnet_cidr}"
    })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.common_tags, {
    Name = "IGW For VPC"
    })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(var.common_tags, {
    Name = "Route Table"
    })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_traffic" {

    vpc_id = aws_vpc.this.id

    dynamic "ingress" {
        for_each = var.allow_sg_ports
        content {
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.common_tags, {
        Name = "SG Allow Traffic ${var.vpc_cidr}"
    })
}