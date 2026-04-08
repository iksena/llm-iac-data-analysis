data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_kms_secrets" "creds" {
  secret {
    name = "db"
    payload = file("${path.module}/db_creds.yaml.encrypted")
  }
}