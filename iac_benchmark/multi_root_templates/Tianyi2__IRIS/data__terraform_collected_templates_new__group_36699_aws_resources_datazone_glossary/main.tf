resource "aws_datazone_glossary" "this" {
  name                      = var.name
  owning_project_identifier = var.owning_project_identifier
  domain_identifier         = var.domain_identifier
  description               = var.description
  status                    = var.status
}