provider "aws" {
  region  = "us-east-1"  
}

resource "aws_instance" "lab_terraform" {
  ami           = "ami-0a0d9cf81c479446a"  # AMI na AWS
  instance_type = "t2.micro"

  tags = {
    Name = "lab-terraform"
  }
}
