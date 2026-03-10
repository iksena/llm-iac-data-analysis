# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/count-for-if/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16"
    }
  }
}
provider "aws" {
  region = var.region
}

# ── variables.tf ────────────────────────────────────
variable "region" {
  description = "Region variable"
  type        = string
  default     = "us-east-1"
}

variable "users" {
  description = "List of users to create"
  type        = list(string)
  default     = ["bob", "fred", "anna", "andrew", "victor", "samara"]
}

# ── outputs.tf ────────────────────────────────────
output "created_users_all" {
  description = "List of all created IAM users as resources"
  value       = aws_iam_user.users
}

output "created_users_all_ids" {
  description = "List of IDs of all created IAM users"
  value       = [for user in aws_iam_user.users : user.id]
}

output "created_users_all_custom" {
  description = "Custom details for all created IAM users"
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.name} with ARN: ${user.arn}"
  ]
}

output "created_users_map" {
  description = "Mapping of unique IDs to IAM user IDs"
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id
  }
}

# print all users with length 4 
output "selected_users" {
  description = "Custom if for users"
  value = [
    for x in aws_iam_user.users :
    x.name
    if length(x.name) == 4
  ]
}

output "ec2_info" {
  value = [for instance in aws_instance.ubuntu_instance : instance.id]
}

output "ec2_id_ip" {
  value = {
    for server in aws_instance.ubuntu_instance :
    server.id => server.public_ip
  }
}

# ── datasource.tf ────────────────────────────────────
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# ── instances.tf ────────────────────────────────────
resource "aws_instance" "ubuntu_instance" {
    count         = 2
    ami           = data.aws_ami.latest_ubuntu.id
    instance_type = "t2.micro"
    tags = {
        Name = "Server Number: ${count.index + 1}"
    }
}

# ── users.tf ────────────────────────────────────
resource "aws_iam_user" "users" {
  count = length(var.users)
  name  = element(var.users, count.index)
}