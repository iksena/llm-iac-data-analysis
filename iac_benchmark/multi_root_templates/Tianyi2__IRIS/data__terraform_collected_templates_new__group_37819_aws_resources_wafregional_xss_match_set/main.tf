resource "aws_wafregional_xss_match_set" "this" {
  region = var.region
  name   = var.name

  dynamic "xss_match_tuple" {
    for_each = var.xss_match_tuples
    content {
      text_transformation = xss_match_tuple.value.text_transformation

      field_to_match {
        data = xss_match_tuple.value.field_to_match.data
        type = xss_match_tuple.value.field_to_match.type
      }
    }
  }
}