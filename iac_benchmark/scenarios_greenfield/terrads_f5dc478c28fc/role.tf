data "aws_iam_policy_document" "assume_role-ec2" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = local.ec2_service_identifiers_by_partition[data.aws_partition.current.partition]
    }
  }
}

locals {
  ec2_service_identifiers_by_partition = {
    "aws" : [
      "ec2.amazonaws.com",
    ]
    "aws-cn" : [
      "ec2.amazonaws.com.cn",
    ]
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = local.name
  path = local.path
  role = aws_iam_role.role.id
}

resource "aws_iam_role" "role" {
  name               = local.name
  path               = local.path
  assume_role_policy = data.aws_iam_policy_document.assume_role-ec2.json
}
