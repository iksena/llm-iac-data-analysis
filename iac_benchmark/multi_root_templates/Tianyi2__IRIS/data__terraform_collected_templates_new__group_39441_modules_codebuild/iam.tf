locals {
  project_role_name = "${substr(var.name, 0, 32)}-"
}

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

data "aws_iam_policy_document" "build" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:${var.name}-*:*"
    ]
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
      variable = "ec2:Subnet"
      values = formatlist(
        "arn:aws:ec2:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:subnet/%s",
        var.vpc_config_subnets
      )
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
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
  description = "${var.name} store artefacts"

  policy = data.aws_iam_policy_document.build.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Step = var.name
  }, var.tags)
}

resource "aws_iam_role" "build" {
  name_prefix        = local.project_role_name
  description        = "${var.name} build"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json

  tags = merge({
    Step = var.name
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "build" {
  role       = aws_iam_role.build.name
  policy_arn = aws_iam_policy.build.arn
}
