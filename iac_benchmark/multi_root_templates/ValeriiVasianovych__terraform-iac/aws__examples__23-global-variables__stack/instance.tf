resource "aws_instance" "example" {
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = local.instance_types["micro"]
  key_name        = "ServersKey"
  security_groups = [aws_security_group.example.name]
  user_data = templatefile("nginx-server.sh.tpl", {
    region = "${local.region}"
  })

  tags = merge(local.common_tags, {
    Name = "${local.env}-instance"
  })
}

resource "aws_security_group" "example" {
  name_prefix = "security-group"
  description = "An example security group for Terraform"

  dynamic "ingress" {
    for_each = local.security_group_ingress
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

  tags = merge(local.common_tags, {
    Name = "${local.env}-security-group"
  })
}