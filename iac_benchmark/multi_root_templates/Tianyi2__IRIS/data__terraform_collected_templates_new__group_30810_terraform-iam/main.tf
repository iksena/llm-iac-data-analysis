terraform {
  required_version = ">= 0.12.6"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = var.region
}

data "aws_iam_policy_document" "codecommit_secrets_setup_policy_document" {
  statement {
    sid = "1"
    actions = [
      "codecommit:CreateRepository",
      "codecommit:DeleteRepository",
      "codecommit:GetRepository",
      "codecommit:ListRepositories",
      "codecommit:ListTagsForResource"
    ]

    resources = ["*"]
  }

  statement {
    sid = "2"
    actions = [
      "kms:CreateKey",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "kms:ScheduleKeyDeletion"
    ]

    resources = ["*"]
  }

  statement {
    sid = "3"
    actions = [
      "iam:CreateRole",
      "iam:GetRole",
      "iam:DeleteRole",
      "iam:CreatePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:ListAttachedRolePolicies",
      "iam:DeletePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListInstanceProfilesForRole",
      "iam:UpdateAssumeRolePolicy"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "codecommit_secrets_setup_policy" {
  name = "${var.repo_name}-setup"
  policy = data.aws_iam_policy_document.codecommit_secrets_setup_policy_document.json
}


data "aws_iam_policy_document" "codecommit_secrets_role_assumption_policy_document" {
  statement {
    principals {
      type = "AWS"
      identifiers = var.allowed_users
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "codecommit_secrets_setup_role" {
  name = "${var.repo_name}-setup"
  assume_role_policy = data.aws_iam_policy_document.codecommit_secrets_role_assumption_policy_document.json
}

resource "aws_iam_role_policy_attachment" "codecommit_secrets_setup_attachment" {
  role       = aws_iam_role.codecommit_secrets_setup_role.name
  policy_arn = aws_iam_policy.codecommit_secrets_setup_policy.arn
}