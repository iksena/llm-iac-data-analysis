locals {
  allowed_instance_type = ["t2.micro"]
}

data "aws_ami" "ubuntu" {

  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_key_pair" "flask_app_key_pair" {
  key_name   = var.key_pair_name
  public_key = var.public_key
}

resource "aws_instance" "flask_app_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = aws_key_pair.flask_app_key_pair.key_name

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  lifecycle {
    precondition {
      condition     = contains(local.allowed_instance_type, var.instance_type)
      error_message = "var - Invalid instance type. Only t2.micro is allowed."
    }

    postcondition {
      condition     = contains(local.allowed_instance_type, self.instance_type)
      error_message = "Self - Invalid instance type. Only t2.micro is allowed."
    }
  }
}