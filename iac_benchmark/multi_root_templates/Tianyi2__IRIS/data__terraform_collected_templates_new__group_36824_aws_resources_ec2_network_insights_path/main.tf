resource "aws_ec2_network_insights_path" "this" {
  source   = var.source_resource
  protocol = var.protocol

  region           = var.region
  source_ip        = var.source_ip
  destination      = var.destination
  destination_ip   = var.destination_ip
  destination_port = var.destination_port

  dynamic "filter_at_destination" {
    for_each = var.filter_at_destination != null ? [var.filter_at_destination] : []
    content {
      destination_address = filter_at_destination.value.destination_address
      source_address      = filter_at_destination.value.source_address

      dynamic "destination_port_range" {
        for_each = filter_at_destination.value.destination_port_range != null ? [filter_at_destination.value.destination_port_range] : []
        content {
          from_port = destination_port_range.value.from_port
          to_port   = destination_port_range.value.to_port
        }
      }

      dynamic "source_port_range" {
        for_each = filter_at_destination.value.source_port_range != null ? [filter_at_destination.value.source_port_range] : []
        content {
          from_port = source_port_range.value.from_port
          to_port   = source_port_range.value.to_port
        }
      }
    }
  }

  dynamic "filter_at_source" {
    for_each = var.filter_at_source != null ? [var.filter_at_source] : []
    content {
      destination_address = filter_at_source.value.destination_address
      source_address      = filter_at_source.value.source_address

      dynamic "destination_port_range" {
        for_each = filter_at_source.value.destination_port_range != null ? [filter_at_source.value.destination_port_range] : []
        content {
          from_port = destination_port_range.value.from_port
          to_port   = destination_port_range.value.to_port
        }
      }

      dynamic "source_port_range" {
        for_each = filter_at_source.value.source_port_range != null ? [filter_at_source.value.source_port_range] : []
        content {
          from_port = source_port_range.value.from_port
          to_port   = source_port_range.value.to_port
        }
      }
    }
  }

  tags = var.tags
}