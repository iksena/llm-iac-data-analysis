To fulfill the business need, we will create an AWS Elastic File System (EFS) and set up a mount target for it. The EFS will be created in a specified VPC and subnet, and we will ensure that the necessary security group is in place to allow NFS traffic. We will use the AWS provider and specify a region for deployment. The configuration will include the creation of a VPC, a subnet, a security group, the EFS itself, and a mount target within the specified subnet.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
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
  availability_zone = "us-west-2a"

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_security_group" "efs_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 2049
    to_port     = 2049
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
    Name = "efs-security-group"
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token = "my-efs"

  tags = {
    Name = "my-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.efs_sg.id]
}
```
</iac_template>

This configuration sets up a VPC and a subnet in the `us-west-2` region, creates a security group to allow NFS traffic, and then creates an EFS with a mount target in the specified subnet. The security group is configured to allow inbound NFS traffic on port 2049 from any IP address.