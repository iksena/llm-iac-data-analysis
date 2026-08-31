provider "aws" {
  profile = var.profile
  region = var.region

  assume_role {
    role_arn = var.assumeRole ? "arn:aws:iam::${var.accountID}:role/${var.assumableRole}" : null
  }
}

resource "aws_iam_account_password_policy" "vss" {
  count = var.password_configuration_enabled ? 1 : 0

  allow_users_to_change_password = var.password_configuration_allow_users_to_change_password
  require_numbers                = var.password_configuration_require_numbers
  require_symbols                = var.password_configuration_require_symbols
  require_lowercase_characters   = var.password_configuration_require_lowercase_characters
  require_uppercase_characters   = var.password_configuration_require_uppercase_characters
  minimum_password_length        = var.password_configuration_minimum_length

  password_reuse_prevention      = var.password_configuration_reuse_prevention
  max_password_age               = var.password_configuration_max_age
}

resource "aws_organizations_organization" "vss_org" {
  count = var.analyzer_enabled && var.analyzer_type == "ORGANIZATION" ? 1 : 0
  aws_service_access_principals = ["access-analyzer.amazonaws.com"]
}

resource "aws_accessanalyzer_analyzer" "vss_org" {
  count = var.analyzer_enabled && var.analyzer_type == "ORGANIZATION" ? 1 : 0

  analyzer_name = var.analyzer_name
  type          = "ORGANIZATION"

  depends_on = [aws_organizations_organization.vss_org[0]]
}

resource "aws_accessanalyzer_analyzer" "vss" {
  count = var.analyzer_enabled && var.analyzer_type == "ACCOUNT" ? 1 : 0

  analyzer_name = var.analyzer_name
  type          = "ACCOUNT"
}

resource "aws_iam_saml_provider" "vss" {
  count = var.saml_enabled ? 1 : 0

  name                   = var.saml_name
  saml_metadata_document = file("${var.saml_path}/${var.saml_name}.xml")
}

resource "aws_iam_user" "vss" {
  count = var.user_create ? 1 : 0

  name          = var.user_name
  path          = var.user_path

  force_destroy = var.user_force_destroy
}

resource "aws_iam_access_key" "vss" {
  count = var.access_key_create ? 1 : 0

  user          = var.access_key_user_name
}

resource "aws_iam_policy" "vss" {
  count = var.policy_create ? 1 : 0

  name = var.policy_name
  policy = var.policy_environment != "" ? file("${var.policy_path}/${var.policy_name}-${var.policy_environment}.json") : file("${var.policy_path}/${var.policy_name}.json")
}

resource "aws_iam_role" "vss" {
  count = var.role_create ? 1 : 0

  name                  = var.role_name
  assume_role_policy    = var.role_environment != "" ? file("${var.role_path}/${var.role_name}-${var.role_environment}.json") : file("${var.role_path}/${var.role_name}.json")

  managed_policy_arns   = var.role_policies

  max_session_duration  = var.role_session_duration
}

resource "aws_iam_instance_profile" "vss" {
  count = var.role_create ? 1 : 0

  name                  = var.role_name
  role                  = aws_iam_role.vss[0].name
}

resource "aws_iam_group" "vss" {
  count = var.group_create ? 1 : 0

  name  = var.group_name
  path  = var.group_path
}

resource "aws_iam_group_membership" "vss" {
  count = var.group_create ? 1 : 0

  name  = "${var.group_name}-membership"
  users = var.group_users

  group = aws_iam_group.vss[0].name
}

resource "aws_iam_group_policy_attachment" "vss" {
  count = var.group_create ? 1 : 0

  group      = aws_iam_group.vss[0].name
  policy_arn = var.group_policy
}