The Terraform program will create an AWS Virtual Private Cloud (VPC) with a single subnet. It will then launch an EC2 instance within this subnet. The instance will use an Ubuntu 20.04 AMD64 Amazon Machine Image (AMI), which will be dynamically looked up using the AWS Systems Manager (SSM) Parameter Store. The configuration will include the necessary IAM roles and security group to allow SSH access to the instance. The AWS provider will be configured to use a specific region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main-subnet"
  }
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "web-server"
  }
}
```
</iac_template>