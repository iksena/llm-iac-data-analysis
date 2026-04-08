resource "aws_verifiedaccess_endpoint" "this" {
  attachment_type          = var.attachment_type
  endpoint_domain_prefix   = var.endpoint_domain_prefix
  endpoint_type            = var.endpoint_type
  verified_access_group_id = var.verified_access_group_id

  region                 = var.region
  application_domain     = var.application_domain
  description            = var.description
  domain_certificate_arn = var.domain_certificate_arn
  policy_document        = var.policy_document
  security_group_ids     = var.security_group_ids

  dynamic "sse_specification" {
    for_each = var.sse_specification != null ? [var.sse_specification] : []
    content {
      customer_managed_key_enabled = try(sse_specification.value.customer_managed_key_enabled, null)
      kms_key_arn                  = try(sse_specification.value.kms_key_arn, null)
    }
  }

  dynamic "load_balancer_options" {
    for_each = var.load_balancer_options != null ? [var.load_balancer_options] : []
    content {
      load_balancer_arn = load_balancer_options.value.load_balancer_arn
      port              = load_balancer_options.value.port
      protocol          = load_balancer_options.value.protocol
      subnet_ids        = load_balancer_options.value.subnet_ids
    }
  }

  dynamic "network_interface_options" {
    for_each = var.network_interface_options != null ? [var.network_interface_options] : []
    content {
      network_interface_id = network_interface_options.value.network_interface_id
      port                 = network_interface_options.value.port
      protocol             = network_interface_options.value.protocol
    }
  }

  dynamic "cidr_options" {
    for_each = var.cidr_options != null ? [var.cidr_options] : []
    content {
      cidr       = cidr_options.value.cidr
      protocol   = cidr_options.value.protocol
      subnet_ids = cidr_options.value.subnet_ids

      dynamic "port_range" {
        for_each = cidr_options.value.port_range != null ? [cidr_options.value.port_range] : []
        content {
          from_port = port_range.value.from_port
          to_port   = port_range.value.to_port
        }
      }
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}