resource "aws_wafregional_size_constraint_set" "this" {
  region = var.region
  name   = var.name

  dynamic "size_constraints" {
    for_each = var.size_constraints
    content {
      comparison_operator = size_constraints.value.comparison_operator
      size                = size_constraints.value.size
      text_transformation = size_constraints.value.text_transformation

      field_to_match {
        data = size_constraints.value.field_to_match.data
        type = size_constraints.value.field_to_match.type
      }
    }
  }
}