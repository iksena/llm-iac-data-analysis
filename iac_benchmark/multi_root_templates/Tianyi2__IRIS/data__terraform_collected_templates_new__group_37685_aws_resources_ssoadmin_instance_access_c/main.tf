resource "aws_ssoadmin_instance_access_control_attributes" "this" {
  region       = var.region
  instance_arn = var.instance_arn

  dynamic "attribute" {
    for_each = var.attributes
    content {
      key = attribute.value.key
      value {
        source = attribute.value.value.source
      }
    }
  }
}