resource "aws_sfn_alias" "this" {
  region      = var.region
  name        = var.name
  description = var.description

  dynamic "routing_configuration" {
    for_each = var.routing_configuration
    content {
      state_machine_version_arn = routing_configuration.value.state_machine_version_arn
      weight                    = routing_configuration.value.weight
    }
  }
}