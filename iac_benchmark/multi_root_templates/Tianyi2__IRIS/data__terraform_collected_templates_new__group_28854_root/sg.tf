resource "aws_security_group" "bastion" {
  name   = var.name
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}

data "aws_iam_policy_document" "s3_bucket_access" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.ssh_public_keys.arn}/${aws_s3_object.ssh_public_keys.key}"]
  }
}

data "aws_region" "current" {}

resource "aws_vpc_endpoint" "s3_bucket" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
  policy       = data.aws_iam_policy_document.s3_bucket_access.json
}

resource "aws_security_group_rule" "s3_egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "443"
  protocol          = "TCP"
  cidr_blocks       = aws_vpc_endpoint.s3_bucket.cidr_blocks
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_ssh_ingress" {
  type              = "ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidrs
  security_group_id = aws_security_group.bastion.id
}

resource "aws_security_group_rule" "bastion_all_egress" {
  count = var.create_egress_rule ? 1 : 0

  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "all"
  cidr_blocks       = var.allowed_egress_cidrs
  ipv6_cidr_blocks  = var.allowed_ipv6_egress_cidrs
  security_group_id = aws_security_group.bastion.id
}
