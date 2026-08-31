# get the most recent Amazon Linux 2 AMI
data "aws_ami" "ec2_ami" {
  most_recent           = true
  owners                = ["amazon"]

  filter {
    name                = "name"
    values              = ["amzn2-ami-hvm-2*"]
  }

  filter {
    name                = "architecture"
    values              = ["x86_64"]
  }

  filter {
    name                = "root-device-type"
    values              = ["ebs"]
  }

  filter {
    name                = "virtualization-type"
    values              = ["hvm"]
  }
}

# create a test ec2 instance to validate SSM session manager access and permissions
resource "aws_instance" "test_instance" {
  ami                   = data.aws_ami.ec2_ami.id
  instance_type         = "t3.small"

  subnet_id             = aws_subnet.priv_subnet.id
  source_dest_check     = false

  vpc_security_group_ids  = [ aws_security_group.ec2_sg.id ]
  iam_instance_profile    = aws_iam_instance_profile.ec2_instance_profile.name

  tags                  = merge(
    local.common_tags, 
    { Name = "${var.app_shortcode}-test" }
  )
}

