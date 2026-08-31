resource "aws_autoscaling_group" "default" {
  name = local.name

  min_size         = 2
  max_size         = 2
  desired_capacity = 2

  vpc_zone_identifier = [aws_subnet.public.id]

  tag {
    key                 = "Name"
    value               = local.name
    propagate_at_launch = true
  }

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.default.id
        version            = aws_launch_template.default.latest_version
      }

      override {
        instance_requirements {
          accelerator_count {
            max = 0
          }

          vcpu_count {
            max = 4
          }

          memory_mib {
            max = 16 * 1024
          }

          memory_gib_per_vcpu {
            max = 4
          }


          spot_max_price_percentage_over_lowest_price = 100
        }
      }
    }
    instances_distribution {
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "price-capacity-optimized"

      spot_instance_pools = 0
    }
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 0
      instance_warmup        = 0
    }
  }
}

resource "aws_key_pair" "default" {
  public_key = var.public_key
}

resource "aws_launch_template" "default" {
  name = local.name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2.name
  }

  image_id      = data.aws_ssm_parameter.ecs_amazon_linux_2.value
  instance_type = "t3a.medium" # supports 3 ENIs
  key_name      = aws_key_pair.default.key_name

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = base64encode(<<EOF
#!/bin/bash
echo "ECS_CLUSTER=${local.name}" >> /etc/ecs/ecs.config
EOF
  )

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = local.name
    }
  }

}

data "aws_ssm_parameter" "ecs_amazon_linux_2" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_security_group" "ec2" {
  vpc_id = aws_vpc.default.id
  name   = "${local.name}-ec2"
}

resource "aws_security_group_rule" "ec2_egress_all" {
  security_group_id = aws_security_group.ec2.id

  type = "egress"

  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks = ["0.0.0.0/0"]
  description = "allows EC2 hosts to make egress calls"
}

resource "aws_security_group_rule" "ec2_ingress_ssh" {
  security_group_id = aws_security_group.ec2.id

  type = "ingress"

  from_port = 22
  to_port   = 22
  protocol  = "tcp"

  cidr_blocks = [var.admin_cidr]
  description = "allows ssh from admin_cidr"
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${local.name}-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_policy_attachment" "ec2_ecs" {
  name       = "${local.name}-ec2"
  roles      = [aws_iam_role.ec2.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_policy_attachment" "ec2_ssm" {
  name       = "${local.name}-ec2"
  roles      = [aws_iam_role.ec2.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${aws_iam_role.ec2.name}-instance-profile"
  role = aws_iam_role.ec2.name
}

data "aws_iam_policy_document" "policy_describe" {
  statement {
    effect = "Allow"
    actions = ["ec2:DescribeImages"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ec2_policy_describe" {
  policy = data.aws_iam_policy_document.policy_describe.json
  role   = aws_iam_role.ec2.name
}