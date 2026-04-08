resource "aws_datasync_location_azure_blob" "this" {
  region              = var.region
  access_tier         = var.access_tier
  agent_arns          = var.agent_arns
  authentication_type = var.authentication_type
  blob_type           = var.blob_type
  container_url       = var.container_url
  subdirectory        = var.subdirectory
  tags                = var.tags

  dynamic "sas_configuration" {
    for_each = var.sas_configuration != null ? [var.sas_configuration] : []
    content {
      token = sas_configuration.value.token
    }
  }
}