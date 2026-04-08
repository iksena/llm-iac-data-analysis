resource "aws_sagemaker_project" "this" {
  project_name        = var.project_name
  project_description = var.project_description
  region              = var.region

  service_catalog_provisioning_details {
    path_id                  = var.service_catalog_provisioning_details.path_id
    product_id               = var.service_catalog_provisioning_details.product_id
    provisioning_artifact_id = var.service_catalog_provisioning_details.provisioning_artifact_id

    dynamic "provisioning_parameter" {
      for_each = var.service_catalog_provisioning_details.provisioning_parameters != null ? var.service_catalog_provisioning_details.provisioning_parameters : []
      content {
        key   = provisioning_parameter.value.key
        value = provisioning_parameter.value.value
      }
    }
  }

  tags = var.tags
}