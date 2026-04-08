terraform {
  # cloud {
  #   organization = "terraform-cloud-local"

  #   workspaces {
  #     name = "cli-driven-workspace" 
  #   }
  # }

  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt      = true
    key          = "aws/tfstates/test-solutions/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

###########################################################################

# Datasources
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

###########################################################################

# Provider
provider "aws" {
  region = var.region
}

###########################################################################

# module "aws_vpc" {
#     // source = "git@github.com:valeriiVasianovych/terraform-aws-vpc.git//modules/aws_vpc" Use for remote module
#     source = "./modules/aws_vpc"
#     region = "eu-central-1"
#     env = "dev"
#     vpc_cidr = "192.168.0.0/16"
#     public_subnet_cidrs = [
#         "192.168.10.0/24"
#         # "192.168.11.0/24",
#         # "192.168.12.0/24"
#     ]
#     private_subnet_cidrs = [
#         "192.168.20.0/24"
#         # "192.168.21.0/24",
#         # "192.168.22.0/24"
#     ]
#     common_tags = {
#         Owner : "Peter Parker"
#         Project : "Terraform AWS VPC"
#     }
# }

###########################################################################

# Resources
# resource "aws_instance" "example_ec2" {
#   ami           = data.aws_ami.latest_ubuntu.id
#   instance_type = lookup(var.instance_types, var.environment, "t3.micro")
#   # instance_type = (terraform.workspace == "dev" ? "t3.micro" : "t2.medium")
#   # availability_zone      = module.vpc.azs[0]
#   key_name               = "ServersKey"
#   # vpc_security_group_ids = [aws_security_group.tf-sg.id]

#   tags = merge(var.common_tags, {
#     Name = "ec2-instance"
#     Environment = "${var.environment}"
#   })

#   provisioner "file" {
#     source      = "${path.module}/data.json"
#     destination = "/tmp/data.json"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "cd /tmp",
#       "ls -al",
#       "cat data.json",
#       "ps -ef"
#     ]
#   }

#   provisioner "local-exec" {
#     command = "echo 'Instance created!'"
#   }

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("~/.ssh/ServersKey.pem")
#     host        = self.public_ip
#   }
# }

# resource "aws_s3_bucket" "tf-s3-bucket" {
#   bucket = "terraform-s3-bucket-vasianovych-2"
#   depends_on = [aws_security_group.tf-sg]
# }

# resource "aws_security_group" "tf-sg" {
#   name        = "tf-sg"
#   description = "An example security group for Terraform"

#   dynamic "ingress" {
#     for_each = [80, 443, 22, 3306]
#     content {
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name  = "tf-sg"
#     Owner = "Valerii Vasianovych"
#   }

#   lifecycle {
#     replace_triggered_by = [aws_s3_bucket.tf-s3-bucket] # This security group will be replaced when the s3 bucket is replaced
#     create_before_destroy = true          # Creates a new security group before destroying the old one if the resource is being replaced
#     ignore_changes = ["ingress", "name"]  # ingnores changes in the ingress and name attributes
#     prevent_destroy = true                # Prevents the security group from being destroyed. It will return an error if you try to destroy it

#   }
# }

resource "aws_security_group" "web" {
  name = "web-sg"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}