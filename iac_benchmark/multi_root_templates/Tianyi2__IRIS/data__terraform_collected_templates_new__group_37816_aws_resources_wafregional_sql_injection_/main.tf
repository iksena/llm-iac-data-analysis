resource "aws_wafregional_sql_injection_match_set" "this" {
  region = var.region
  name   = var.name

  dynamic "sql_injection_match_tuple" {
    for_each = var.sql_injection_match_tuple
    content {
      text_transformation = sql_injection_match_tuple.value.text_transformation

      field_to_match {
        data = sql_injection_match_tuple.value.field_to_match.data
        type = sql_injection_match_tuple.value.field_to_match.type
      }
    }
  }
}