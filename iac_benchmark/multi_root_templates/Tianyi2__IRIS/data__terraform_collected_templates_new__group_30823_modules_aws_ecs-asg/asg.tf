data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

# resource "aws_launch_configuration" "lc" {

#   name          = "${var.cluster_name}-launch-configuration"
#   image_id      = data.aws_ami.amazon_linux.id
#   instance_type = var.instance_type
#   lifecycle {
#     create_before_destroy = true
#     ignore_changes = [image_id]
#   }
#   iam_instance_profile        = var.iam_instance_profile
#   key_name                    = var.key_name
#   security_groups             = ["${aws_security_group.cluster.id}"]
#   associate_public_ip_address = true
#   user_data                   = <<EOF
# #! /bin/bash
# sudo apt-get update
# sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
# EOF
# }

data "template_file" "user_data_hw" {
  template =  <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_launch_template" "template" {
  name = "${var.cluster_name}-template"

  iam_instance_profile {
    name = var.iam_instance_profile
  }
  image_id = data.aws_ami.amazon_linux.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = var.instance_type
  key_name = var.key_name
  disable_api_stop = false
  disable_api_termination = false

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.disk_size
    }
  }

  network_interfaces {
    security_groups = ["${aws_security_group.cluster.id}"]
    associate_public_ip_address = true
    delete_on_termination = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name" = "${var.cluster_name}-EC2"
      "Terraform" = "true"
    }

  } 

  user_data = "${base64encode(data.template_file.user_data_hw.rendered)}"              

  lifecycle {
    create_before_destroy = true
    ignore_changes = [image_id]
  }

}

resource "aws_autoscaling_group" "asg" {

  name                      = "${var.cluster_name}-asg"

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.min_size
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = var.subnets

  launch_template {
    id = aws_launch_template.template.id
    version = "$Latest"
  }

  target_group_arns     = [var.target_group_arn]
  force_delete          = var.force_delete
  protect_from_scale_in = var.protect_from_scale_in
  placement_group           = var.create_placement_strategy ? one(aws_placement_group.strategy[*].id) : null
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-EC2"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}