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

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "build" {
  statement {
    actions = [
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]
    resources = [
      "${var.s3_bucket_arn}/*/build_outp/*"
    ]
  }
}

resource "aws_iam_policy" "store_artifacts" {
  name_prefix = substr(var.step_name, 0, 32)
  description = "${var.step_name} store artefacts"

  policy = data.aws_iam_policy_document.build.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Step = var.step_name
  }, var.tags)
}

resource "aws_iam_role" "build" {
  name_prefix        = substr(var.step_name, 0, 32)
  description        = "${var.step_name} build"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json

  tags = merge({
    Step = var.step_name
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  count      = length(local.managed_policy_arns)
  role       = aws_iam_role.build.name
  policy_arn = local.managed_policy_arns[count.index]
}

data "aws_iam_policy_document" "step_assume_roles" {
  count = length(var.step_assume_roles) == 0 ? 0 : 1
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    resources = values(var.step_assume_roles)
  }
}

resource "aws_iam_policy" "step_assume_roles" {
  count       = length(var.step_assume_roles) == 0 ? 0 : 1
  name_prefix = substr(var.step_name, 0, 32)
  policy      = data.aws_iam_policy_document.step_assume_roles[0].json
  description = "${var.step_name} step assume roles"

  tags = var.tags
}

locals {
  default_policy_arns = concat([aws_iam_policy.store_artifacts.arn], var.policy_arns)
  managed_policy_arns = length(var.step_assume_roles) == 0 ? local.default_policy_arns : concat(local.default_policy_arns, [aws_iam_policy.step_assume_roles[0].arn])
}
