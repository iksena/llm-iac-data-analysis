terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/tasks/aws-ec2/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "ubuntu_ec2" {
    count = var.count_instance
    ami = data.aws_ami.latest_ubuntu.id
    availability_zone = "${var.region}a"
    instance_type = var.instance_type
    key_name = var.key_name
    user_data = file("${path.module}/install-nginx.sh")
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = merge(var.common_tags, {
        Name = "ec2-instance-${count.index + 1}"
    })
}

resource "aws_security_group" "sg" {
  name   = "sg"
  description = "An example security group for Terraform"

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

    tags = merge(var.common_tags, {
        Name = "sg"
    })
}