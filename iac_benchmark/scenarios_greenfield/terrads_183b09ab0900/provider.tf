provider "aws" {
  allowed_account_ids = ["373612170290"]
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key
  region     = var.region
}