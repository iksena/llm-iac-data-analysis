resource "aws_iot_topic_rule_destination" "this" {
  region  = var.region
  enabled = var.enabled

  vpc_configuration {
    role_arn        = var.vpc_configuration.role_arn
    security_groups = var.vpc_configuration.security_groups
    subnet_ids      = var.vpc_configuration.subnet_ids
    vpc_id          = var.vpc_configuration.vpc_id
  }
}