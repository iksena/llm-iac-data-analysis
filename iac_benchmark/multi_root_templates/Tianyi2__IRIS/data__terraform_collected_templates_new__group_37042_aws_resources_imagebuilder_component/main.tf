locals {
  # Validate mutual exclusivity of data and uri
  data_uri_validation = (var.data == null ? 0 : 1) + (var.uri == null ? 0 : 1) == 1 ? null : tobool("data and uri are mutually exclusive - exactly one must be specified")
}

resource "aws_imagebuilder_component" "this" {
  name     = var.name
  platform = var.platform
  version  = var.component_version

  region                = var.region
  change_description    = var.change_description
  data                  = var.data
  description           = var.description
  kms_key_id            = var.kms_key_id
  skip_destroy          = var.skip_destroy
  supported_os_versions = var.supported_os_versions
  tags                  = var.tags
  uri                   = var.uri

  depends_on = [local.data_uri_validation]
}