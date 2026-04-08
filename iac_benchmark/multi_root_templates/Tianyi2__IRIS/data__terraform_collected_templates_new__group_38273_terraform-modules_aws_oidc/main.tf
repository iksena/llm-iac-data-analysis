locals {
  # https://github.blog/changelog/2023-06-27-github-actions-update-on-oidc-integration-with-aws/
  additional_thumbprints = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  iam_policy_arn = var.iam_policy_arn != "" ? var.iam_policy_arn : aws_iam_policy.this[0].arn
}

data "tls_certificate" "this" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_openid_connect_provider" "this" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = distinct(concat(data.tls_certificate.this.certificates[*].sha1_fingerprint, local.additional_thumbprints))

  tags = var.tags
}

resource "aws_iam_role" "this" {
  name               = "github-actions-oidc"
  description        = "The role used by the Github repo ${var.repo_name} to manage AWS resources"
  assume_role_policy = data.aws_iam_policy_document.iam_role_assume_role.json

  managed_policy_arns = [local.iam_policy_arn]
  tags                = var.tags
}

data "aws_iam_policy_document" "iam_role_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:iss"
      values   = ["https://token.actions.githubusercontent.com"]
    }


    condition {
      test     = "ForAnyValue:StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = concat(
        ["repo:${var.repo_name}:${var.allowed_refs}"],
        [
          for repo, details in var.additional_allowed_repos :
          "repo:${repo}:${details.sub}"
        ]
      )

    }
  }
}

resource "aws_iam_policy" "this" {
  count = var.iam_policy_arn == "" ? 1 : 0

  name = "github-actions-oidc"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:*",
          "ecr:*",
          "s3:*",
          "servicediscovery:*",
          "application-autoscaling:*",
          "logs:*",
          "elasticache:*",
          "elasticloadbalancing:*",
          "ecs:*",
          "ec2:*"
        ],
        "Resource" : [
          "*"
        ],
        "Condition" : {
          "StringEquals" : {
            "aws:RequestedRegion" : ["eu-west-2"]
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole",
          "iam:GetPolicy",
          "iam:GetRole",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:UpdateRole",
          "iam:DeleteRole",
          "iam:CreateRole",
          "iam:ListRoles",
          "iam:ListRoleTags",
          "iam:ListRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:ListAttachedRolePolicies",
          "iam:GetRolePolicy",
          "iam:GetServiceLinkedRoleDeletionStatus",
          "iam:GetPolicyVersion",
          "iam:ListPolicies",
          "iam:ListPoliciesGrantingServiceAccess",
          "iam:ListPolicyTags",
          "iam:ListPolicyVersions",
          "iam:AttachRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:UpdateAssumeRolePolicy",
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:CreatePolicy",
          "iam:CreatePolicyVersion",
          "iam:GetOpenIDConnectProvider"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

