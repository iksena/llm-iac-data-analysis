data "aws_ami" "evergreen_node" {
  most_recent = true
  owners      = ["891459268445"]

  filter {
    name   = "name"
    values = ["evergreen-amd64-amazon-linux-2023-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## EC2 Instance for the NAT Gateway using fck-nat
## ---------------------------------------------------------------------------------------------------------------------

data "aws_ami" "fck_nat" {
  most_recent = true
  owners      = ["568608671756"]

  filter {
    name   = "name"
    values = ["fck-nat-al2023-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_instance" "nat_gateway" {
  instance_type = "t4g.nano"
  ami           = data.aws_ami.fck_nat.id

  iam_instance_profile = aws_iam_instance_profile.nat_service_role.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.nat.id
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = false
  disable_api_termination = false

  tags = {
    Name = "evergreen-prod-nat"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## ---------------------------------------------------------------------------------------------------------------------
## EC2 Launch Template and ASG for AMD64 Evergreen Nodes
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_template" "evergreen_amd64" {
  name        = "evergreen-prod-node-amd64"
  description = "Evergreen node launch template"

  instance_type          = "t3.small"
  image_id               = data.aws_ami.evergreen_node.id
  vpc_security_group_ids = [aws_security_group.evergreen_node.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.evergreen_node_service_role.arn
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = false
  disable_api_termination = false

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 35
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "evergreen-prod-node"
    }
  }
}

resource "aws_autoscaling_group" "evergreen_amd64_scaling_group" {
  name = "evergreen-prod-nodes-amd64"

  desired_capacity = 1
  max_size         = 1
  min_size         = 1

  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.evergreen_amd64.id
    version = aws_launch_template.evergreen_amd64.latest_version
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
