/* ----------------------------------------------------------------------------
    IAM setup

      Create a new AWS member account for IAM handling only. This is where each
      member will get access to, and they will assume role from other accounts.
------------------------------------------------------------------------------- */
resource "aws_organizations_account" "iam" {
  name  = var.project_name_iam
  email = var.project_email_iam
}

/* ----------------------------------------------------------------------------
    TerraformSuperAdmin setup

      Create user account "TerraformSuperAdmin". This account is only meant to
      be used for another account creation and items here.
------------------------------------------------------------------------------- */
data "aws_iam_policy_document" "terraform_super_admin" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}
resource "aws_iam_user" "terraform_super_admin" {
  name = "TerraformSuperAdmin"
  path = "/"
}
resource "aws_iam_user_policy" "terraform_super_admin_access" {
  name   = "TerraformSuperAdminAccess"
  user   = aws_iam_user.terraform_super_admin.name
  policy = data.aws_iam_policy_document.terraform_super_admin.json
}
resource "aws_iam_access_key" "terraform_super_admin" {
  user    = aws_iam_user.terraform_super_admin.name
  pgp_key = "keybase:${var.keybase_userid}"
}

/* ----------------------------------------------------------------------------
    TerraformAdmin setup

      Create user account "TerraformAdmin" so that it can assume role from
      other accounts.
------------------------------------------------------------------------------- */
data "aws_iam_policy_document" "terraform_admin" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}
resource "aws_iam_user" "terraform_admin" {
  name = "TerraformAdmin"
  path = "/"
}
resource "aws_iam_user_policy" "terraform_admin_access" {
  name   = "TerraformAdminAccess"
  user   = aws_iam_user.terraform_admin.name
  policy = data.aws_iam_policy_document.terraform_admin.json
}
resource "aws_iam_access_key" "terraform_admin" {
  user    = aws_iam_user.terraform_admin.name
  pgp_key = "keybase:${var.keybase_userid}"
}
