provider "aws" {
  region = var.region

  default_tags {
    tags = {
        Project = "Terraform recreate specific instance"
        Owner = "Valerii Vasianovych"
    }
  }
}

resource "aws_instance" "ec2_instance-1" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  tags = {
    Name = "Instance-1"
  }
}

# Example 1
# terraform plan -replace=aws_instance.ec2_instance-2

# Example 2
# terraform taint aws_instance.ec2_instance-2
# terraform plan
# terraform untaint aws_instance.ec2_instance-2
# # terraform plan
resource "aws_instance" "ec2_instance-2" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  tags = {
    Name = "Instance-2"
  }
}