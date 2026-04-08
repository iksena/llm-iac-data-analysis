resource "aws_datazone_project" "this" {
  domain_identifier   = var.domain_identifier
  name                = var.name
  region              = var.region
  skip_deletion_check = var.skip_deletion_check
  description         = var.description
  glossary_terms      = var.glossary_terms

  timeouts {
    create = "10m"
    delete = "10m"
  }
}