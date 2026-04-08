module "ci_alerts_sns_topic" {
  source = "../modules//sns_topic"

  topic_name = "ci-alerts"
  subscriber_account_numbers = [
    data.aws_secretsmanager_secret_version.sandbox_account_id.secret_string,
    data.aws_secretsmanager_secret_version.development_account_id.secret_string,
    data.aws_secretsmanager_secret_version.production_account_id.secret_string,
    data.aws_secretsmanager_secret_version.central_audit_development_account_id.secret_string,
    data.aws_secretsmanager_secret_version.central_audit_production_account_id.secret_string,
  ]
}