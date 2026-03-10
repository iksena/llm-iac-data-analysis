# ── main.tf ────────────────────────────────────
# Copyright (c) 2021, 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_core_vcn" "main" {
  cidr_blocks             = var.cidr_blocks
  compartment_id          = var.compartment_ocid
  display_name            = var.display_name
  dns_label               = var.dns_label
  freeform_tags           = var.vcn_tags.freeformTags
  defined_tags            = var.vcn_tags.definedTags
  is_ipv6enabled          = var.is_ipv6enabled
  ipv6private_cidr_blocks = var.ipv6private_cidr_blocks

  count = var.create_new_vcn ? 1 : 0
}

# ── variables.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "compartment_ocid" {}
variable "create_new_vcn" {
  default     = true
  description = "Creates a new Virtual Cloud Network (VCN). If false, the VCN OCID must be provided in the variable 'existent_vcn_ocid'."
}
variable "existent_vcn_ocid" {
  default     = ""
  description = "Using existent Virtual Cloud Network (VCN) OCID."
}
variable "cidr_blocks" {
  default     = ["10.20.0.0/16"]
  description = "IPv4 CIDR Blocks for the Virtual Cloud Network (VCN). If use more than one block, separate them with comma. e.g.: 10.20.0.0/16,10.80.0.0/16"
}
variable "display_name" {
  default     = "Dev VCN 1"
  description = "Display name for the Virtual Cloud Network (VCN)."
}
variable "dns_label" {
  default     = "vcn1"
  description = "DNS Label for Virtual Cloud Network (VCN)."
}
variable "is_ipv6enabled" {
  default     = false
  description = "Whether IPv6 is enabled for the Virtual Cloud Network (VCN)."
}
variable "ipv6private_cidr_blocks" {
  default     = []
  description = "The list of one or more ULA or Private IPv6 CIDR blocks for the Virtual Cloud Network (VCN)."
}

# Deployment Details + Freeform Tags + Defined Tags
variable "vcn_tags" {
  description = "Tags to be added to the VCN resources"
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "vcn_id" {
  value = data.oci_core_vcn.main_or_existent.id
}
output "default_dhcp_options_id" {
  value = data.oci_core_vcn.main_or_existent.default_dhcp_options_id
}
output "compartment_id" {
  value = data.oci_core_vcn.main_or_existent.compartment_id
}
output "default_route_table_id" {
  value = data.oci_core_vcn.main_or_existent.default_route_table_id
}
output "default_security_list_id" {
  value = data.oci_core_vcn.main_or_existent.default_security_list_id
}
output "dns_label" {
  value = data.oci_core_vcn.main_or_existent.dns_label
}
output "display_name" {
  value = data.oci_core_vcn.main_or_existent.display_name
}
output "cidr_blocks" {
  value = data.oci_core_vcn.main_or_existent.cidr_blocks
}
output "byoipv6cidr_blocks" {
  value = data.oci_core_vcn.main_or_existent.byoipv6cidr_blocks
}
output "ipv6cidr_blocks" {
  value = data.oci_core_vcn.main_or_existent.ipv6cidr_blocks
}
output "ipv6private_cidr_blocks" {
  value = data.oci_core_vcn.main_or_existent.ipv6private_cidr_blocks
}
output "vcn_domain_name" {
  value = data.oci_core_vcn.main_or_existent.vcn_domain_name
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
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

data "oci_core_vcn" "main_or_existent" {
  vcn_id = var.create_new_vcn ? oci_core_vcn.main[0].id : var.existent_vcn_ocid
}