resource "aws_waf_regex_match_set" "this" {
  name = var.name

  dynamic "regex_match_tuple" {
    for_each = var.regex_match_tuples
    content {
      field_to_match {
        data = regex_match_tuple.value.field_to_match.data
        type = regex_match_tuple.value.field_to_match.type
      }
      regex_pattern_set_id = regex_match_tuple.value.regex_pattern_set_id
      text_transformation  = regex_match_tuple.value.text_transformation
    }
  }
}