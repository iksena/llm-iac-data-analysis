terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
   region     = "us-east-1"
}

resource "aws_ebs_volume" "ebsvolume" {
  availability_zone ="us-east-1a"
  size = 10
  encrypted = false
  tags = {
    Name = "azterravol"
  }
}

resource "aws_instance" "azterraec2" {
  ami = "ami-04a41c7299f3874c5"
  instance_type = "t2.micro"
  subnet_id = "subnet-0410fd190e31b6625"
  vpc_security_group_ids = ["sg-0c1163c54bca806a5"]
  user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update && sudo apt upgrade -y 
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      EOF
  associate_public_ip_address = true
  key_name = "ec2-nv-kp"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ec2-terraform"
  }
}
resource "aws_volume_attachment" "mountvolumetoec2" {
  device_name = "/dev/sdb"
  instance_id = aws_instance.azterraec2.id
  volume_id = aws_ebs_volume.ebsvolume.id
}
