data "aws_key_pair" "this" {
  region             = var.region
  key_pair_id        = var.key_pair_id
  key_name           = var.key_name
  include_public_key = var.include_public_key

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  timeouts {
    read = "20m"
  }
}