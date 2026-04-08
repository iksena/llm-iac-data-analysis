resource "aws_wafregional_regex_pattern_set" "this" {
  region                = var.region
  name                  = var.name
  regex_pattern_strings = var.regex_pattern_strings
}