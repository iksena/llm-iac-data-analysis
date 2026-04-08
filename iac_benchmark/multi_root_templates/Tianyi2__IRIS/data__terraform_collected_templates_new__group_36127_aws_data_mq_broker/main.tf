data "aws_mq_broker" "this" {
  broker_id   = var.broker_id
  broker_name = var.broker_name
  region      = var.region
}