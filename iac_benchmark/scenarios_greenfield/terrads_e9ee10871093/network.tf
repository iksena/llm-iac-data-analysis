locals {
  vpc_cidr_block      = "10.0.0.0/16"
  private_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  public_cidr_blocks  = ["10.0.101.0/24", "10.0.102.0/24"]
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block
}

# from outside to inside: Internet Gateway --> Route Table --> Subnet  --> Security Group

################### Internet Gateway ###################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}


################### Route Table ###################
# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


################### Subnet ###################
# Public Subnet
resource "aws_subnet" "public" {
  count             = length(local.public_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_cidr_blocks[count.index]
  availability_zone = var.aws_availability_zones[count.index]
}

# Private Subnet
resource "aws_subnet" "private" {
  count             = length(local.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_cidr_blocks[count.index]
  availability_zone = var.aws_availability_zones[count.index]
}


################### Security Group ###################
# Public Security Group (ALB)
resource "aws_security_group" "alb" {
  name        = "public-sg-alb"
  description = "Allow HTTP inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_ingress_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_egress_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocols, all ports
}

# ECS Security Group
resource "aws_security_group" "ecs_task" {
  name        = "ecs-task-sg"
  description = "Allow inbound traffic from ALB to ECS"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "ecs_task_ingress_alb" {
  security_group_id            = aws_security_group.ecs_task.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "-1" # all protocols, all ports
}

resource "aws_vpc_security_group_egress_rule" "ecs_task_egress" {
  security_group_id = aws_security_group.ecs_task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocols, all ports
}

# Private Security Group
resource "aws_security_group" "private" {
  name   = "private-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "private_ingress_from_public" {
  security_group_id            = aws_security_group.private.id
  referenced_security_group_id = aws_security_group.ecs_task.id
  description                  = "Allow ECS to access PostgresSQL"
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

resource "aws_vpc_security_group_egress_rule" "private_egress_all" {
  security_group_id = aws_security_group.private.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all ports
}
