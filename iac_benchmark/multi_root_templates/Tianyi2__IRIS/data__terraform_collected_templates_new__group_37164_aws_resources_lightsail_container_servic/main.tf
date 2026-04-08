resource "aws_lightsail_container_service" "this" {
  name        = var.name
  power       = var.power
  scale       = var.scale
  is_disabled = var.is_disabled
  region      = var.region
  tags        = var.tags

  dynamic "private_registry_access" {
    for_each = var.private_registry_access != null ? [var.private_registry_access] : []
    content {
      dynamic "ecr_image_puller_role" {
        for_each = private_registry_access.value.ecr_image_puller_role != null ? [private_registry_access.value.ecr_image_puller_role] : []
        content {
          is_active = ecr_image_puller_role.value.is_active
        }
      }
    }
  }

  dynamic "public_domain_names" {
    for_each = var.public_domain_names != null ? [var.public_domain_names] : []
    content {
      dynamic "certificate" {
        for_each = public_domain_names.value.certificate
        content {
          certificate_name = certificate.value.certificate_name
          domain_names     = certificate.value.domain_names
        }
      }
    }
  }
}