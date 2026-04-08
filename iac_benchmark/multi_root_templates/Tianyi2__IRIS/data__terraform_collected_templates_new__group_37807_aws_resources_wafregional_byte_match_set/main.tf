resource "aws_wafregional_byte_match_set" "this" {
  region = var.region
  name   = var.name

  dynamic "byte_match_tuples" {
    for_each = var.byte_match_tuples
    content {
      positional_constraint = byte_match_tuples.value.positional_constraint
      target_string         = byte_match_tuples.value.target_string
      text_transformation   = byte_match_tuples.value.text_transformation

      field_to_match {
        data = byte_match_tuples.value.field_to_match.data
        type = byte_match_tuples.value.field_to_match.type
      }
    }
  }
}