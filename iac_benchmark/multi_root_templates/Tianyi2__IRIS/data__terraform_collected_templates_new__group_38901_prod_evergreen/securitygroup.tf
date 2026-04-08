## ---------------------------------------------------------------------------------------------------------------------
## Security groups for items in the public subnets.
##
## The public instances are currently configured to only allow HTTP and HTTPS traffic from the internet. This is done on
## purpose to prevent anybody from trying to SSH into the instances. The instances don't have a SSH key associated with
## them, so they can't be SSH-ed into regardless.
##
## Anybody interested in receiving shell access to any of the instances should use AWS Systems Manager Session Manager.
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "nat" {
  name        = "evergreen-prod-nat"
  description = "Evergreen NAT security group"
  vpc_id      = aws_vpc.evergreen.id

  ingress {
    description = "Allow any traffic from within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.evergreen.cidr_block]
  }

  egress {
    description = "Allow any traffic to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "alb" {
  name        = "evergreen-prod-alb"
  description = "Evergreen ALB security group"
  vpc_id      = aws_vpc.evergreen.id

  ingress {
    description = "Allow HTTP and HTTPS traffic from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP and HTTPS traffic from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow any traffic to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## Security groups for the container service nodes
##
## The container service nodes are deployed in the private subnets. They are not accessible from the internet, but they
## should be able to reach the internet through the NAT gateway.
##
## The reason we allow all traffic from within the VPC is because we run ECS in bridge mode, which means that the
## tasks run on random ports. If we used the host mode, we could restrict traffic to specific ports where we know that
## services are running, but this means we have to manually configure globally unique ports for each service.
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "evergreen_node" {
  name        = "evergreen-prod-node"
  description = "Evergreen node security group"
  vpc_id      = aws_vpc.evergreen.id

  ingress {
    description = "Allow any traffic from within the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.evergreen.cidr_block]
  }

  egress {
    description = "Allow any traffic to the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
