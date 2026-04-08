resource "aws_waf_xss_match_set" "this" {
  name = var.name

  dynamic "xss_match_tuples" {
    for_each = var.xss_match_tuples
    content {
      text_transformation = xss_match_tuples.value.text_transformation

      field_to_match {
        type = xss_match_tuples.value.field_to_match.type
        data = xss_match_tuples.value.field_to_match.data
      }
    }
  }
}