resource "aws_transcribe_medical_vocabulary" "this" {
  vocabulary_name     = var.vocabulary_name
  language_code       = var.language_code
  vocabulary_file_uri = var.vocabulary_file_uri
  region              = var.region
  tags                = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}