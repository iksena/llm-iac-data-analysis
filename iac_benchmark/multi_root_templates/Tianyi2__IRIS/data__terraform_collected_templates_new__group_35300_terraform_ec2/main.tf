data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_ami" "project_centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["project-centos"]
  }

  owners = ["self"]
}

resource "aws_instance" "project_centos" {
  ami                         = data.aws_ami.project_centos.id
  instance_type               = "t2.micro"
  subnet_id                   = element(var.public_subnet_ids, 0) 
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  tags = {
    Name = "project_centos"
  }
}

resource "aws_security_group" "ec2" {
  name        = "project-centos"
  description = "Outbound access"
  vpc_id      = var.vpc_id

  // outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project-centos-security-group-outbound"
  }
}

resource "aws_security_group_rule" "ec2_allow_ssh" {
  description       = "Allow ssh access"
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2.id

}
