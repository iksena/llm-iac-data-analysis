data "aws_secretsmanager_secret_version" "github_token" {
  secret_id = "/service_accounts/github_api_token"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
