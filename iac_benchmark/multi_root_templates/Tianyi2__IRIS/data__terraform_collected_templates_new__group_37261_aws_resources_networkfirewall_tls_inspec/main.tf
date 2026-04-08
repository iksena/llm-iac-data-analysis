resource "aws_networkfirewall_tls_inspection_configuration" "this" {
  name        = var.name
  description = var.description
  region      = var.region

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      key_id = encryption_configuration.value.key_id
      type   = encryption_configuration.value.type
    }
  }

  tls_inspection_configuration {
    dynamic "server_certificate_configuration" {
      for_each = var.tls_inspection_configuration.server_certificate_configurations
      content {
        certificate_authority_arn = server_certificate_configuration.value.certificate_authority_arn

        dynamic "check_certificate_revocation_status" {
          for_each = server_certificate_configuration.value.check_certificate_revocation_status != null ? [server_certificate_configuration.value.check_certificate_revocation_status] : []
          content {
            revoked_status_action = check_certificate_revocation_status.value.revoked_status_action
            unknown_status_action = check_certificate_revocation_status.value.unknown_status_action
          }
        }

        dynamic "server_certificate" {
          for_each = server_certificate_configuration.value.server_certificates
          content {
            resource_arn = server_certificate.value.resource_arn
          }
        }

        dynamic "scope" {
          for_each = server_certificate_configuration.value.scopes
          content {
            protocols = scope.value.protocols

            dynamic "destination" {
              for_each = scope.value.destinations
              content {
                address_definition = destination.value.address_definition
              }
            }

            dynamic "destination_ports" {
              for_each = scope.value.destination_ports
              content {
                from_port = destination_ports.value.from_port
                to_port   = destination_ports.value.to_port
              }
            }

            dynamic "source" {
              for_each = scope.value.sources
              content {
                address_definition = source.value.address_definition
              }
            }

            dynamic "source_ports" {
              for_each = scope.value.source_ports
              content {
                from_port = source_ports.value.from_port
                to_port   = source_ports.value.to_port
              }
            }
          }
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  tags = var.tags
}