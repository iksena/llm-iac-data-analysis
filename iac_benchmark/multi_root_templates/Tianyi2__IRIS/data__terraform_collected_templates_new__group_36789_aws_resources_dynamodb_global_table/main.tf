resource "aws_dynamodb_global_table" "this" {
  name = var.name

  dynamic "replica" {
    for_each = var.replica
    content {
      region_name = replica.value.region_name
    }
  }
}