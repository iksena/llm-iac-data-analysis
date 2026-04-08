locals {
  # Validate that phrases and vocabulary_file_uri are mutually exclusive
  validation_check = var.phrases != null && var.vocabulary_file_uri != null ? tobool("Only one of phrases or vocabulary_file_uri can be specified") : true
}

resource "aws_transcribe_vocabulary" "this" {
  language_code       = var.language_code
  vocabulary_name     = var.vocabulary_name
  region              = var.region
  phrases             = var.phrases
  vocabulary_file_uri = var.vocabulary_file_uri
  tags                = var.tags

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}