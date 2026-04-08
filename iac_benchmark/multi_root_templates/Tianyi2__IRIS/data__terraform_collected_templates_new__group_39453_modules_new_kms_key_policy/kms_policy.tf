locals {
  default_services = ["access-analyzer.amazonaws.com"]

  readers = var.read_roles != null ? var.read_roles : formatlist(
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/%s",
    ["RoleTerraformApplier", "RoleTerraformPlanner", "RoleSecurityEngineer", "RoleKmsAdministrator", "RoleProwlerScanner"]
  )

  describers = var.read_roles != null ? var.read_roles : formatlist(
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/%s",
    ["RoleTerraformApplier", "RoleTerraformPlanner", "RoleSecurityEngineer", "RoleKmsAdministrator", "RoleProwlerScanner"]
  )

  writers = var.write_roles != null ? var.write_roles : formatlist(
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/%s",
    ["RoleTerraformApplier", "RoleSecurityEngineer"]
  )

  admins = var.admin_roles != null ? var.admin_roles : formatlist(
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/%s",
    ["RoleKmsAdministrator", "RoleTerraformApplier"]
  )

  read_services = distinct(concat(local.default_services, var.read_services))

  write_services = var.write_services

  all_roles = distinct(concat(local.admins, local.writers, local.readers, local.describers))
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms" {

  statement {
    sid    = "DenyAccessToDecrypt"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "kms:Decrypt",
    ]

    resources = ["*"]

    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      // writers need to be able to decrypt as part of a MultiPartUpload
      values = distinct(concat(local.readers, local.writers))
    }

    condition {
      test     = "StringNotLike"
      variable = "aws:Service"
      values   = distinct(concat(local.read_services, local.write_services))
    }

    dynamic "condition" {
      for_each = var.read_service_conditions

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }

  statement {
    sid    = "DenyAccessToNonWriteUsers"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
    ]

    resources = ["*"]

    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values   = local.writers
    }
    condition {
      test     = "StringNotLike"
      variable = "aws:Service"
      values   = local.write_services
    }

    dynamic "condition" {
      for_each = var.write_service_conditions

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }

  statement {
    sid    = "DenyAccessToNonKMSAdmin"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "kms:Create*",
      "kms:Enable*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = local.admins
    }
  }

  statement {
    sid    = "DenyGetAccessToNonKMSAdmin"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "kms:GetParametersForImport",
      "kms:GetPublicKey",
    ]

    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = local.admins
    }
  }

  statement {
    sid    = "DenyAccessToNonKMSAdminAndDescribeRoles"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "kms:Describe*",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:List*",
    ]

    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = local.describers
    }
  }

  statement {
    sid    = "DenyUnknownKMSActions"
    effect = "Deny"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    not_actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
      "kms:Decrypt",
    ]

    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalArn"
      values   = local.admins
    }
  }

  /*
    kms actions are explicitly denied to everyone that
    should not have them
  */
  statement {
    sid    = "AllowAccessForUsers"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "kms:*",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:PrincipalArn"
      values   = local.all_roles
    }
  }
}