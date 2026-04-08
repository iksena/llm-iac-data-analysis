resource "aws_instance" "ec2_instance_lookups" {
  ami = "data.aws_ami.latest_ubuntu"
  # instance_type = lookup(var.instance_size, "staging")
  instance_type          = (var.env == "Development" ? var.instance_size["dev"] : var.instance_size["prod"])
  vpc_security_group_ids = [aws_security_group.sg_lookups.id]
  key_name               = "ServerKey"
  tags = {
    Region        = var.region
    Owner         = "Valerii Vasianovych"
    Env           = var.env
    Instance-Type = (var.env == "Development" ? var.instance_size["dev"] : var.instance_size["prod"])
  }
}

resource "aws_security_group" "sg_lookups" {
  name        = "Web Security Group"
  description = "Securit Group for instance"
  dynamic "ingress" {
    for_each = (var.env == "Development" ? var.sg_lookup_ports["dev"] : var.sg_lookup_ports["prod"])
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

  tags = {
    Region = var.region
    Owner  = "Valerii Vasianovych"
    Env    = var.env
  }
}