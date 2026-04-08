resource "aws_transcribe_vocabulary_filter" "this" {
  language_code          = var.language_code
  vocabulary_filter_name = var.vocabulary_filter_name

  vocabulary_filter_file_uri = var.vocabulary_filter_file_uri
  words                      = var.words

  tags = var.tags
}