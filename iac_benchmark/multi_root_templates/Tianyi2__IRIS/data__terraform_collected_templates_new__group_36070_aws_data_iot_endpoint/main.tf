data "aws_iot_endpoint" "this" {
  region        = var.region
  endpoint_type = var.endpoint_type
}