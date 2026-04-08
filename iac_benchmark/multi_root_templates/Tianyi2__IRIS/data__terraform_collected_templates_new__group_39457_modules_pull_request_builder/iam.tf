locals {
  default_policy_arns = [aws_iam_policy.build.arn, aws_iam_policy.build_core.arn]
  managed_policy_arns = length(var.project_assume_roles) == 0 ? local.default_policy_arns : concat(local.default_policy_arns, [aws_iam_policy.project_assume_roles[0].arn])
  project_role_name   = substr(var.project_name, 0, 32)
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "build" {
  name_prefix        = local.project_role_name
  description        = "${var.project_name} build"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json

  tags = merge({
    Step = var.project_name
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  count      = length(local.managed_policy_arns)
  role       = aws_iam_role.build.name
  policy_arn = local.managed_policy_arns[count.index]
}

data "aws_iam_policy_document" "build" {
  statement {
    actions   = ["codeconnections:UseConnection"]
    resources = [var.codeconnection_arn]

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "codeconnections:FullRepositoryId"
      values   = ["${var.src_org}/${var.src_repo}"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "codeconnections:ProviderPermissionsRequired"
      values   = ["read_only"]
    }
  }

  statement {
    actions = [
      "codeconnections:GetConnectionToken",
      "codeconnections:GetConnection"
    ]

    resources = [var.codeconnection_arn]
  }
}

resource "aws_iam_policy" "build" {
  name_prefix = local.project_role_name
  description = "${var.project_name} store artefacts"

  policy = data.aws_iam_policy_document.build.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Step = var.project_name
  }, var.tags)
}

data "aws_iam_policy_document" "project_assume_roles" {
  count = length(var.project_assume_roles) == 0 ? 0 : 1
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    resources = values(var.project_assume_roles)
  }
}

resource "aws_iam_policy" "project_assume_roles" {
  count       = length(var.project_assume_roles) == 0 ? 0 : 1
  name_prefix = local.project_role_name
  policy      = data.aws_iam_policy_document.project_assume_roles[0].json
  description = "${var.project_name} codebuild project assume roles"
  tags        = var.tags
}

data "aws_iam_policy_document" "build_core" {

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  # https://docs.aws.amazon.com/codebuild/latest/userguide/auth-and-access-control-iam-identity-based-access-control.html#customer-managed-policies-example-create-vpc-network-interface
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:CreateNetworkInterfacePermission",
    ]
    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:network-interface/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values = [
        "codebuild.amazonaws.com"
      ]
    }
    condition {
      test     = "ArnEquals"
      variable = "ec2:Subnet"
      values   = var.vpc_config.private_subnet_arns
    }
  }

  statement {
    actions   = ["codeconnections:UseConnection"]
    resources = [var.codeconnection_arn]

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "codeconnections:FullRepositoryId"
      values   = ["${var.src_org}/${var.src_repo}"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "codeconnections:ProviderPermissionsRequired"
      values   = ["read_only"]
    }
  }
}

resource "aws_iam_policy" "build_core" {
  name_prefix = local.project_role_name
  description = "${var.project_name} build"
  policy      = data.aws_iam_policy_document.build_core.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    codebuild_project = var.project_name
  }, var.tags)
}
