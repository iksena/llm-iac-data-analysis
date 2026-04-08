resource "aws_controltower_control" "this" {
  control_identifier = var.control_identifier
  target_identifier  = var.target_identifier
  region             = var.region

  dynamic "parameters" {
    for_each = var.parameters
    content {
      key   = parameters.value.key
      value = parameters.value.value
    }
  }
}