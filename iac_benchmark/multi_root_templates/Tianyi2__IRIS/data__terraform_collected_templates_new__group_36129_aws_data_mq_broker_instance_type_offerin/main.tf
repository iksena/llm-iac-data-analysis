data "aws_mq_broker_instance_type_offerings" "this" {
  engine_type        = var.engine_type
  host_instance_type = var.host_instance_type
  region             = var.region
  storage_type       = var.storage_type
}