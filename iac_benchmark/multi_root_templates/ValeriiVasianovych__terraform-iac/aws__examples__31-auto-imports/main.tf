provider "aws" {
  region = "us-east-1"
}

import {
  id = "sg-0bc61af652e9c65e1"
  to = aws_security_group.security_group_general
}

import {
  id = "i-021a08b14c1f36800"
  to = aws_instance.ubuntu_ec2_1
}

import {
  id = "i-0b4b93aa3f3b4d82e"
  to = aws_instance.ubuntu_ec2_2
}