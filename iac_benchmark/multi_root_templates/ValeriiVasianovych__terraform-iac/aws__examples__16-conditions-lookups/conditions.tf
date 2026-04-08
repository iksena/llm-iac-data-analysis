resource "aws_instance" "ec2_instance_conditions" {
  count                  = (var.env == "Development" ? 1 : 3)
  ami                    = "data.aws_ami.latest_ubuntu"
  instance_type          = (var.env == "Development" ? "t2.micro" : "t3.medium")
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.sg_conditions.id]
  monitoring             = (var.env == "Development" ? false : true)

  tags = {
    Region = var.region
    Owner  = "Valerii Vasianovych"
    Env    = var.env
  }
}

resource "aws_security_group" "sg_conditions" {
  name        = "Web Security Group"
  description = "Securit Group for instance"
  dynamic "ingress" {
    for_each = (var.env == "Development" ? [80, 22] : var.sg_ports)
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