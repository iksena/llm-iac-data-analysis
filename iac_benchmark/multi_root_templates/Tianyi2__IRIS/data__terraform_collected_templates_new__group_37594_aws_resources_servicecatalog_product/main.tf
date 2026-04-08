resource "aws_servicecatalog_product" "this" {
  name                = var.name
  owner               = var.owner
  type                = var.type
  region              = var.region
  accept_language     = var.accept_language
  description         = var.description
  distributor         = var.distributor
  support_description = var.support_description
  support_email       = var.support_email
  support_url         = var.support_url
  tags                = var.tags

  provisioning_artifact_parameters {
    description                 = var.provisioning_artifact_parameters.description
    disable_template_validation = var.provisioning_artifact_parameters.disable_template_validation
    name                        = var.provisioning_artifact_parameters.name
    template_physical_id        = var.provisioning_artifact_parameters.template_physical_id
    template_url                = var.provisioning_artifact_parameters.template_url
    type                        = var.provisioning_artifact_parameters.type
  }

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}