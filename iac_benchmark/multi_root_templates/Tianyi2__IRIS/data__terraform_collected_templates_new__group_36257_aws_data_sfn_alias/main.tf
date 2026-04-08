data "aws_sfn_alias" "this" {
  region           = var.region
  name             = var.name
  statemachine_arn = var.statemachine_arn
}