resource "aws_instance" "instance-1" {
  provider        = aws.region-1
  ami             = data.aws_ami.latest_ubuntu_region_1.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.security_group_region_1.name]
  #   key_name        = "SeversKey"
  user_data = templatefile("scripts/nginx-server-1.sh.tpl", {
    region = "${var.region_name[0]}"
  })
  tags = {
    Name = "Instance-${var.region_name[0]}"
  }
}

resource "aws_instance" "instance-2" {
  provider        = aws.region-2
  ami             = data.aws_ami.latest_ubuntu_region_2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.security_group_region_2.name]
  #   key_name        = "SeversKey"
  user_data = templatefile("scripts/nginx-server-2.sh.tpl", {
    region = "${var.region_name[1]}"
  })
  tags = {
    Name = "Instance-${var.region_name[1]}"
  }
}

resource "aws_security_group" "security_group" {
  provider = aws.region-1
  dynamic "ingress" {
    for_each = [22, 80, 443]
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
}

resource "aws_security_group" "security_group_region_1" {
  provider = aws.region-1
  dynamic "ingress" {
    for_each = [22, 80, 443]
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
}

resource "aws_security_group" "security_group_region_2" {
  provider = aws.region-2
  dynamic "ingress" {
    for_each = [22, 80, 443]
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
}

resource "aws_route53_health_check" "health_check_instance_1" {
  provider = aws.region-1
  type     = "HTTP"
  fqdn              = aws_instance.instance-1.public_dns
  ip_address        = aws_instance.instance-1.public_ip
  port              = 80
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "HealthCheck-${var.region_name[0]}-Instance-1"
  }
}

resource "aws_route53_health_check" "health_check_instance_2" {
  provider = aws.region-2
  type     = "HTTP"
  fqdn              = aws_instance.instance-2.public_dns
  ip_address        = aws_instance.instance-2.public_ip
  port              = 80
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "HealthCheck-${var.region_name[1]}-Instance-2"
  }
}