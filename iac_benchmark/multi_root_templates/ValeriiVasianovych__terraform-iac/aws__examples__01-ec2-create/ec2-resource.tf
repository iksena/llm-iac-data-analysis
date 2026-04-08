resource "aws_instance" "ubuntu_instance" {
    ami                    = data.aws_ami.latest_ubuntu.id
    instance_type          = var.instance_type
    key_name               = "ServersKey"
    vpc_security_group_ids = [aws_security_group.instance_security_group.id]
    user_data              = file("install-nginx.sh")
    monitoring             = var.monitoring_value

    tags = merge(var.common_tags, {
      Name = "Latest Ubuntu Instance"
      Year = 2024
    })
}

resource "aws_security_group" "instance_security_group" {
  name        = "Instance Security Group"
  description = "Allow HTTP and HTTPS inbound traffic"

  dynamic "ingress" {
    for_each = var.allow_security_groups_ports
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
        Name = "Instance Security Group"
        Year = 2024
    })
}
