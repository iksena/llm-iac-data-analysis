resource "aws_datazone_form_type" "this" {
  domain_identifier         = var.domain_identifier
  name                      = var.name
  owning_project_identifier = var.owning_project_identifier

  model {
    smithy = var.model_smithy
  }

  description = var.description
  status      = var.status
}