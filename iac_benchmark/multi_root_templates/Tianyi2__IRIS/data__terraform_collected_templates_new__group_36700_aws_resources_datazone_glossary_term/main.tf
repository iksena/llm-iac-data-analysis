resource "aws_datazone_glossary_term" "this" {
  domain_identifier   = var.domain_identifier
  glossary_identifier = var.glossary_identifier
  name                = var.name

  region            = var.region
  long_description  = var.long_description
  short_description = var.short_description
  status            = var.status

  dynamic "term_relations" {
    for_each = var.term_relations != null ? [var.term_relations] : []
    content {
      classifies = term_relations.value.classifies
      is_a       = term_relations.value.is_a
    }
  }

  timeouts {
    create = var.timeouts.create
  }
}