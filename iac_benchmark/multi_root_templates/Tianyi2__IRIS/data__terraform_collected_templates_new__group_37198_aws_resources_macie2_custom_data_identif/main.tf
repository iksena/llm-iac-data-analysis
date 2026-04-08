resource "aws_macie2_custom_data_identifier" "this" {
  region                 = var.region
  regex                  = var.regex
  keywords               = var.keywords
  ignore_words           = var.ignore_words
  name                   = var.name
  name_prefix            = var.name_prefix
  description            = var.description
  maximum_match_distance = var.maximum_match_distance
  tags                   = var.tags
}