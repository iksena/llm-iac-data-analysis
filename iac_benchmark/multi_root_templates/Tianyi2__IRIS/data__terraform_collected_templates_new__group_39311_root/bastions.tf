/*
 * Copyright (C) 2019 Risk Focus, Inc. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  # Amazon
  owners = ["137112412989"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Canonical
  owners = ["099720109477"]
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.bastion_instance_size
  subnet_id     = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id,
    aws_security_group.bastion_incoming_ssh.id,
  ]

  key_name  = var.key_name
  user_data = templatefile("${path.module}/templates/bastion_ssh_keys.sh.tpl", { bastion_ssh_keys = var.bastion_ssh_keys })
  tags      = local.bastion_tags

  lifecycle {
    ignore_changes = [
      ami,
    ]
  }
}

resource "aws_security_group" "allow_ssh_from_bastion" {
  name        = "${var.project_prefix}-eks-bastion_ssh_access"
  description = "Allow SSH from bastion"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [
      aws_security_group.bastion_sg.id,
    ]
  }

  egress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [
      aws_security_group.bastion_sg.id,
    ]
  }
}

resource "aws_security_group" "bastion_incoming_ssh" {
  name        = "${var.project_prefix}-eks-bastion_incoming_ssh"
  description = "Allow SSH to bastion from world"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = var.ip_whitelist
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_prefix}-eks-bastion_sg"
  description = "Bastion SG"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1

    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    security_groups = [
      module.eks.worker_security_group_id,
    ]
  }
}

output "bastion" {
  description = "How to reach bastion"
  value       = "ubuntu@${aws_instance.bastion.public_ip}"
}
