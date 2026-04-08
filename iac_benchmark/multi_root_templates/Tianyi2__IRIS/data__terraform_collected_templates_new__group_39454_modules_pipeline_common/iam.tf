locals {
  pipeline_role_name = substr(local.pipeline_name, 0, 32)
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    principals {
      identifiers = ["codepipeline.amazonaws.com"]
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

data "aws_iam_policy_document" "codepipeline_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:GetObjectVersion",
      "s3:GetObject",
      "s3:GetBucketVersioning"
    ]

    resources = [
      "${module.codepipeline_bucket.arn}/*/source_out/*"
    ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = [
      "arn:aws:codebuild:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:project/${local.pipeline_name}*"
    ]
  }

  statement {
    actions = [
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt",
    ]

    resources = [
      module.codepipeline_bucket.kms_key_arn
    ]
  }

  statement {
    actions   = ["sns:Publish"]
    effect    = "Allow"
    resources = [var.sns_topic_arn]
  }

  dynamic "statement" {
    for_each = var.sns_kms_key_arn != null ? [1] : []
    content {
      actions = [
        "kms:GenerateDataKey",
        "kms:Decrypt",
        "kms:DescribeKey",
      ]
      resources = [var.sns_kms_key_arn]
    }
  }

  dynamic "statement" {
    for_each = length(var.codeconnection_arn) > 0 ? [1] : []

    content {
      actions = [
        "codeconnections:UseConnection",
        "codestar-connections:UseConnection",
      ]

      resources = [var.codeconnection_arn]

      condition {
        test     = "ForAllValues:StringEquals"
        variable = "codeconnections:FullRepositoryId"
        values = [
          "${var.src_org}/${var.src_repo}"
        ]
      }
    }
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name_prefix = local.pipeline_role_name
  description = "${local.pipeline_name} CodePipeline"
  policy      = data.aws_iam_policy_document.codepipeline_policy.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Pipeline = local.pipeline_name
  }, var.tags)
}

resource "aws_iam_role" "codepipeline_role" {
  name_prefix        = local.pipeline_role_name
  description        = "${local.pipeline_name} CodePipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json

  tags = merge({
    Pipeline = local.pipeline_name
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

data "aws_iam_policy_document" "build_core" {

  statement {
    sid = "VpcNetworking"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]

    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:network-interface/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:Subnet"
      values   = var.vpc_config.private_subnet_arns
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:AuthorizedService"
      values   = ["codebuild.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = [
      module.codepipeline_bucket.kms_key_arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
    ]

    resources = [
      "${module.codepipeline_bucket.arn}/*/source_out/*",
      "${module.codepipeline_bucket.arn}/*/build_outp/*",
    ]
  }
}

data "aws_iam_policy_document" "store_artifacts" {
  statement {
    actions = [
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      "${module.codepipeline_bucket.arn}/*/build_outp/*"
    ]
  }
}

resource "aws_iam_policy" "build_core" {
  name_prefix = local.pipeline_role_name
  description = "${local.pipeline_name} build"
  policy      = data.aws_iam_policy_document.build_core.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Pipeline = local.pipeline_name
  }, var.tags)
}

resource "aws_iam_policy" "store_artifacts" {
  name_prefix = local.pipeline_role_name
  description = "${local.pipeline_name} store artefacts"
  policy      = data.aws_iam_policy_document.store_artifacts.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Pipeline = local.pipeline_name
  }, var.tags)
}
