provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "neptune_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "neptune-vpc"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "neptune-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.neptune_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "neptune-subnet-2"
  }
}

resource "aws_neptune_subnet_group" "neptune_subnet_group" {
  name       = "neptune-subnet-group"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "neptune-subnet-group"
  }
}