resource "aws_cloudwatch_log_delivery_destination" "this" {
  name          = var.name
  region        = var.region
  output_format = var.output_format
  tags          = var.tags

  delivery_destination_configuration {
    destination_resource_arn = var.delivery_destination_configuration.destination_resource_arn
  }
}