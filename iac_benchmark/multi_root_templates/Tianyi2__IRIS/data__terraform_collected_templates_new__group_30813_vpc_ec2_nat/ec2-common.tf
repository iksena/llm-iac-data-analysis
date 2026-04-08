locals {
  instance_type = "t3.nano"
  ami           = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221212"
  ami_type      = "hvm"
  ami_owner     = "099720109477"
  volume_type   = "gp3"
  volume_size   = 10
}

resource "aws_key_pair" "this" {
  key_name   = "${local.name}-keypair"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}

data "aws_ami" "this" {
  filter {
    name   = "name"
    values = [local.ami]
  }
  filter {
    name   = "virtualization-type"
    values = [local.ami_type]
  }
  owners      = [local.ami_owner]
  most_recent = true
}
