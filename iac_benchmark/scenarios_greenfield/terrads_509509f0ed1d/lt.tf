resource "aws_launch_template" "weasel_crm_lt" {
  name_prefix            = "weasel-crm-lt"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.weasel_crm_sg_ec2.id]

  tags = {
    Name = "Weasel CRM Project"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
