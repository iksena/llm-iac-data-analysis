resource "aws_globalaccelerator_cross_account_attachment" "this" {
  name       = var.name
  principals = var.principals

  dynamic "resource" {
    for_each = var.resources
    content {
      cidr_block  = resource.value.cidr_block
      endpoint_id = resource.value.endpoint_id
      region      = resource.value.region
    }
  }

  tags = var.tags
}