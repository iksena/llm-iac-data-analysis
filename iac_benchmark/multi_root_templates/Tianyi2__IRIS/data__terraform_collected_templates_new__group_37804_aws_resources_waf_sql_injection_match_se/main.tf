resource "aws_waf_sql_injection_match_set" "this" {
  name = var.name

  dynamic "sql_injection_match_tuples" {
    for_each = var.sql_injection_match_tuples
    content {
      text_transformation = sql_injection_match_tuples.value.text_transformation

      field_to_match {
        data = sql_injection_match_tuples.value.field_to_match.data
        type = sql_injection_match_tuples.value.field_to_match.type
      }
    }
  }
}