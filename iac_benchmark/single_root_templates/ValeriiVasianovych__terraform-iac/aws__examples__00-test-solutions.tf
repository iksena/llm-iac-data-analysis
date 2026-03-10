# ── main.tf ────────────────────────────────────
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

# ── variables.tf ────────────────────────────────────
# Variables
variable "region" {
  type        = string
  description = "The region in which to launch the EC2 instance"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The environment in which to launch the EC2 instance"
  # default     = "dev"
}

variable "instance_types" {
  type        = map(string)
  description = "The types of instances to launch"
  default = {
    dev     = "t2.micro"
    staging = "t2.medium"
    prod    = "t2.large"
  }
}

locals {
  file_content = file("${path.module}/hello-tf.txt")
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default = {
    Owner    = "Valerii Vasianovych"
    Provider = "AWS-Terraform"
  }
}

# variable "1_helloworld" { # incorrect variable name
#   type        = string
#   default     = "Hello World"
# }

# variable "hello_world_2" { # correct variable name
#   type        = string
#   default     = "Hello World"
# }

# ── outputs.tf ────────────────────────────────────
# Outputs
# output "created_instance_type" {
#   value = aws_instance.example_ec2.instance_type
# }

# output "created_instance_az" {
#   value = aws_instance.example_ec2.availability_zone
# }

output "file_content" {
  value = local.file_content
}

output "multiply" {
  value = 2 * 7
}

output "greater_than" {
  value = 5 > 4
}

# output "hello_world" {
#   value = "${var.1_hello_world}"
# }

# ── count-for-if.tf ────────────────────────────────────
variable "aws_users" {
  description = "This is array with names of new users"
  type        = list(string)
  default     = ["ola", "wika", "nastya", "alisa"]
}

# terraform plan -target=aws_ian_user.users
resource "aws_iam_user" "users" {
  count = length(var.aws_users)               # number of users from list
  name  = element(var.aws_users, count.index) # names of users
  tags = {
    Names : "Name of user: ${element(var.aws_users, count.index)}"
    Number : "Number of user from Terraform array: ${count.index + 1}"
  }
}

# attach addministrator policy to users
data "aws_iam_policy" "admin_policy" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "admin_policy" {
  count      = length(var.aws_users)
  user       = element(aws_iam_user.users[*].name, count.index)
  policy_arn = data.aws_iam_policy.admin_policy.arn
}

output "return_users" {
  value = aws_iam_user.users
}

output "iam_users_list" {
  value = [
    for i in aws_iam_user.users :
    "Username: ${i.name} has ARN: ${i.arn} and number in array ${index(aws_iam_user.users[*].name, i.name) + 1}"
  ]
}

output "iam_users_map" {
  value = {
    for i in aws_iam_user.users :
    i.unique_id => "Name of user: ${i.id}"
  }
}

output "show_specific_users" {
  value = [
    for i in aws_iam_user.users :
    i.name if length(i.name) == 4
  ]
}

##############################################################

variable "numbers" {
  description = "This is array with names of new users"
  type        = list(number)
  default     = [1, 2, 3, 4, 5]
}

output "return_numbers" {
  value = length(var.numbers)
}

# ── local_file.tf ────────────────────────────────────
resource "local_file" "foo_file" {
  content  = "The environment of this terraform is: ${var.environment}"
  filename = "${path.module}/local_files/foo_file.txt"
}

variable "files" {
  default = {
    "dev.txt"     = "Development Environment"
    "prod.txt"    = "Production Environment"
    "staging.txt" = "Staging Environment"
  }
}

resource "local_file" "multiple_files" {
  for_each = var.files

  content  = each.value
  filename = "${path.module}/local_files/${each.key}"
}

# ── s3-import.tf ────────────────────────────────────
# Import existing S3 bucket from AWS
resource "aws_s3_bucket" "import-example" {
  bucket = "rds-import-s3-bucket" # actual bucket name in AWS
}

# terraform import aws_s3_bucket.import-example minikube-crossplane-bucket-v2

# ── vpc.tf ────────────────────────────────────
# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "test-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["${var.region}a", "${var.region}b"]
#   private_subnets = []
#   public_subnets  = ["10.0.10.0/24", "10.0.20.0/24"]

#   enable_nat_gateway = false
#   enable_vpn_gateway = false

#   tags = {
#     Terraform = "true"
#   }
# }