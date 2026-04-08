provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner   = "Valerii Vasianovych"
      Project = "Import existing resources from AWS"
    }
  }
}

# terraform import aws_instance.import_node i-2222222222222222e 
resource "aws_instance" "import_node" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  tags = {
    "Name"  = "remote-instance-by-tf"
  }
}

resource "aws_security_group" "import_sg" {
  name        = "ssh-http-https-sg"
  description = "Allows SSH HTTP HTTPS"
  dynamic "ingress" {
    for_each = [80, 443, 22]
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
    "Name"  = "remote-ec2-instance"
  }
}
