resource "aws_waf_byte_match_set" "this" {
  name = var.name

  dynamic "byte_match_tuples" {
    for_each = var.byte_match_tuples
    content {
      text_transformation   = byte_match_tuples.value.text_transformation
      target_string         = byte_match_tuples.value.target_string
      positional_constraint = byte_match_tuples.value.positional_constraint

      field_to_match {
        type = byte_match_tuples.value.field_to_match.type
        data = byte_match_tuples.value.field_to_match.data
      }
    }
  }
}