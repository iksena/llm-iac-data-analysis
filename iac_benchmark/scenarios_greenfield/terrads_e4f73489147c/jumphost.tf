locals {
  demo_ec2_instance_type = "t3.micro"
}

# Latest Amazon Linux 2 AMI

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

# EC2 client Instance Profile

resource "aws_iam_instance_profile" "ec2_client" {
  name = "${local.prefix}-ec2-client"
  role = aws_iam_role.ec2_client.name
}

resource "aws_iam_role" "ec2_client" {
  name = "${local.prefix}-ec2-client"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# EC2 client Security Group

resource "aws_security_group" "ec2_client" {
  name   = "${local.prefix}-ec2-client"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
  local.common_tags,
  {
    Name = "${local.prefix}-ec2-client"
  }
  )
}

# EC2 client instance

resource "aws_iam_policy_attachment" "ec2_client" {
  name       = "${local.prefix}-ec2-client-role-attachment"
  roles      = [aws_iam_role.ec2_client.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_network_interface" "ec2_client" {
  subnet_id   = module.vpc.public_subnets[0]
  private_ips = ["10.0.100.101"]
  security_groups = [aws_security_group.ec2_client.id]
}

resource "aws_instance" "ec2_client" {
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = local.demo_ec2_instance_type
  availability_zone    = "${local.aws_region}a"
  iam_instance_profile = aws_iam_instance_profile.ec2_client.name

  network_interface {
    network_interface_id = aws_network_interface.ec2_client.id
    device_index         = 0
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-ec2-client"
    }
  )
}
