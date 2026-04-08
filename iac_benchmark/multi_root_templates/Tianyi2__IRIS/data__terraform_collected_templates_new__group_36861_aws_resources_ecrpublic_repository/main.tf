resource "aws_ecrpublic_repository" "this" {
  region          = var.region
  repository_name = var.repository_name

  dynamic "catalog_data" {
    for_each = var.catalog_data != null ? [var.catalog_data] : []
    content {
      about_text        = catalog_data.value.about_text
      architectures     = catalog_data.value.architectures
      description       = catalog_data.value.description
      logo_image_blob   = catalog_data.value.logo_image_blob
      operating_systems = catalog_data.value.operating_systems
      usage_text        = catalog_data.value.usage_text
    }
  }

  tags = var.tags

  timeouts {
    delete = var.delete_timeout
  }
}