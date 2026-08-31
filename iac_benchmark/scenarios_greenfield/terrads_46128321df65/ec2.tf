# Dublin - eu-west-1

# Lookup the latest Ubuntu AMI in the eu-west-1 region
data "aws_ami" "ubuntu_dub" {
  provider    = aws.dublin
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
}

# Create the EC2 instances in the eu-west-1 region
resource "aws_instance" "ec2_dub" {
  for_each = {
    for k, v in local.ec2_map : k => v
    if v.region == "eu-west-1"
  }
  provider             = aws.dublin
  ami                  = try(each.value.ami, data.aws_ami.ubuntu_dub.id)
  instance_type        = try(each.value.instance_type, "t4g.micro")
  subnet_id            = try(each.value.subnet, aws_subnet.public_subnet_dub["${each.value.vpc}-${each.value.az}"].id)
  iam_instance_profile = aws_iam_instance_profile.ec2_profile[each.value.ec2_key].name

  user_data                   = ""
  user_data_replace_on_change = try(each.value["user_data_replace_on_change"], false)
  key_name                    = each.value["key_pair"]

  root_block_device {
    encrypted             = try(each.value["root_volume_encrypted"], true)
    volume_type           = try(each.value["root_volume_type"], "gp3")
    volume_size           = try(each.value["root_volume_size"], 30)
    delete_on_termination = try(each.value["root_delete_on_termination"], true)
  }

  tags = merge(local.global_tags, {
    Name         = each.key
    ShutdownTime = each.value.shutdown_time
    StartTime    = each.value.start_time
  })
}

# Virginia - us-east-1

# Lookup the latest Ubuntu AMI in the us-east-1 region
data "aws_ami" "ubuntu_vir" {
  provider    = aws.virginia
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
}

# Create the EC2 instances in the us-east-1 region
resource "aws_instance" "ec2_vir" {
  for_each = {
    for k, v in local.ec2_map : k => v
    if v.region == "us-east-1"
  }
  provider             = aws.virginia
  ami                  = try(each.value.ami, data.aws_ami.ubuntu_vir.id)
  instance_type        = try(each.value.instance_type, "t4g.micro")
  subnet_id            = try(each.value.subnet, aws_subnet.public_subnet_vir["${each.value.vpc}-${each.value.az}"].id)
  iam_instance_profile = aws_iam_instance_profile.ec2_profile[each.value.ec2_key].name

  user_data                   = ""
  user_data_replace_on_change = try(each.value["user_data_replace_on_change"], false)
  key_name                    = each.value["key_pair"]

  root_block_device {
    encrypted             = try(each.value["root_volume_encrypted"], true)
    volume_type           = try(each.value["root_volume_type"], "gp3")
    volume_size           = try(each.value["root_volume_size"], 30)
    delete_on_termination = try(each.value["root_delete_on_termination"], true)
  }

  tags = merge(local.global_tags, {})
}

# Mumbai - ap-south-1

# Lookup the latest Ubuntu AMI in the ap-south-1 region
data "aws_ami" "ubuntu_mum" {
  provider    = aws.mumbai
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
}

# Create the EC2 instances in the ap-south-1 region
resource "aws_instance" "ec2_mum" {
  for_each = {
    for k, v in local.ec2_map : k => v
    if v.region == "ap-south-1"
  }
  provider             = aws.mumbai
  ami                  = try(each.value.ami, data.aws_ami.ubuntu_mum.id)
  instance_type        = try(each.value.instance_type, "t4g.micro")
  subnet_id            = try(each.value.subnet, aws_subnet.public_subnet_mum["${each.value.vpc}-${each.value.az}"].id)
  iam_instance_profile = aws_iam_instance_profile.ec2_profile[each.value.ec2_key].name

  user_data                   = ""
  user_data_replace_on_change = try(each.value["user_data_replace_on_change"], false)
  key_name                    = each.value["key_pair"]

  root_block_device {
    encrypted             = try(each.value["root_volume_encrypted"], true)
    volume_type           = try(each.value["root_volume_type"], "gp3")
    volume_size           = try(each.value["root_volume_size"], 30)
    delete_on_termination = try(each.value["root_delete_on_termination"], true)
  }

  tags = merge(local.global_tags, {})
}