# ── main.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_core_internet_gateway" "gateway" {
  compartment_id = var.compartment_ocid
  display_name   = var.internet_gateway_display_name
  enabled        = var.internet_gateway_enabled
  vcn_id         = var.vcn_id
  route_table_id = var.internet_gateway_route_table_id
  freeform_tags  = var.gateways_tags.freeformTags
  defined_tags   = var.gateways_tags.definedTags

  count = var.create_internet_gateway ? 1 : 0
}

resource "oci_core_nat_gateway" "gateway" {
  block_traffic  = var.nat_gateway_block_traffic
  compartment_id = var.compartment_ocid
  display_name   = var.nat_gateway_display_name
  vcn_id         = var.vcn_id
  public_ip_id   = var.nat_gateway_public_ip_id
  route_table_id = var.nat_gateway_route_table_id
  freeform_tags  = var.gateways_tags.freeformTags
  defined_tags   = var.gateways_tags.definedTags

  count = var.create_nat_gateway ? 1 : 0
   lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
    ]
  }
}

resource "oci_core_service_gateway" "gateway" {
  compartment_id = var.compartment_ocid
  display_name   = var.service_gateway_display_name
  vcn_id         = var.vcn_id
  route_table_id = var.service_gateway_route_table_id
  freeform_tags  = var.gateways_tags.freeformTags
  defined_tags   = var.gateways_tags.definedTags

  services {
    service_id = lookup(data.oci_core_services.all_services.services[0], "id")
  }

  count = var.create_service_gateway ? 1 : 0
}

resource "oci_core_local_peering_gateway" "gateway" {
  compartment_id = var.compartment_ocid
  display_name   = var.local_peering_gateway_display_name
  vcn_id         = var.vcn_id
  peer_id        = var.local_peering_gateway_peer_id
  route_table_id = var.local_peering_gateway_route_table_id
  freeform_tags  = var.gateways_tags.freeformTags
  defined_tags   = var.gateways_tags.definedTags

  count = var.create_local_peering_gateway ? 1 : 0
}

# ── variables.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "compartment_ocid" {}
variable "vcn_id" {}
# Internet Gateway
variable "create_internet_gateway" {
  default     = false
  description = "Create an internet gateway"
}
variable "internet_gateway_display_name" {
  default     = "Internet Gateway"
  description = "Display name for the internet gateway"
}
variable "internet_gateway_enabled" {
  default     = true
  description = "Whether the gateway is enabled upon creation."
}
variable "internet_gateway_route_table_id" {
  default     = null
  description = "The OCID of the route table the internet gateway will use."
}
# NAT Gateway
variable "create_nat_gateway" {
  default     = false
  description = "Create a NAT gateway"
}
variable "nat_gateway_display_name" {
  default     = "NAT Gateway"
  description = "Display name for the NAT gateway"
}
variable "nat_gateway_block_traffic" {
  default     = false
  description = "Whether the NAT gateway blocks traffic through it."
}
variable "nat_gateway_route_table_id" {
  default     = null
  description = "The OCID of the route table the NAT gateway will use."
}
variable "nat_gateway_public_ip_id" {
  default     = null
  description = "The OCID of the public IP the NAT gateway will use."
}
# Service Gateway
variable "create_service_gateway" {
  default     = false
  description = "Create a service gateway"
}
variable "service_gateway_display_name" {
  default     = "Service Gateway"
  description = "Display name for the service gateway"
}
variable "service_gateway_route_table_id" {
  default     = null
  description = "The OCID of the route table the service gateway will use."
}
# Local Peering Gateway (LPG)
variable "create_local_peering_gateway" {
  default     = false
  description = "Create a local peering gateway"
}
variable "local_peering_gateway_display_name" {
  default     = "Local Peering Gateway"
  description = "Display name for the local peering gateway"
}
variable "local_peering_gateway_peer_id" {
  default     = null
  description = "The OCID of the LPG you want to peer with."
}
variable "local_peering_gateway_route_table_id" {
  default     = null
  description = "The OCID of the route table the local peering gateway will use."
}
# Deployment Details + Freeform Tags + Defined Tags
variable "gateways_tags" {
  description = "Tags to be added to the gateway resources"
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "internet_gateway_id" {
  value       = var.create_internet_gateway ? oci_core_internet_gateway.gateway[0].id : null
  description = "The OCID of the Internet Gateway."
}
output "nat_gateway_id" {
  value       = var.create_nat_gateway ? oci_core_nat_gateway.gateway[0].id : null
  description = "The OCID of the NAT Gateway."
}
output "service_gateway_id" {
  value       = var.create_service_gateway ? oci_core_service_gateway.gateway[0].id : null
  description = "The OCID of the Service Gateway."
}
output "local_peering_gateway_id" {
  value       = var.create_local_peering_gateway ? oci_core_local_peering_gateway.gateway[0].id : null
  description = "The OCID of the Local Peering Gateway."
}

# ── providers.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

terraform {
  required_version = ">= 1.1"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4"
      # https://registry.terraform.io/providers/oracle/oci/
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
      # https://registry.terraform.io/providers/hashicorp/local/
    }
  }
}

# ── datasources.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

## Available Services
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}