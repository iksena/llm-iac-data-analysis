# ── main.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_core_subnet" "subnet" {
  cidr_block                 = var.cidr_block
  compartment_id             = var.compartment_ocid
  display_name               = var.display_name
  dns_label                  = var.dns_label
  vcn_id                     = var.vcn_id
  prohibit_public_ip_on_vnic = var.prohibit_public_ip_on_vnic
  prohibit_internet_ingress  = var.prohibit_internet_ingress
  route_table_id             = var.route_table_id
  dhcp_options_id            = var.dhcp_options_id
  security_list_ids          = var.security_list_ids
  ipv6cidr_block             = var.ipv6cidr_block
  freeform_tags              = var.subnet_tags.freeformTags
  defined_tags               = var.subnet_tags.definedTags

  count = var.create_subnet ? 1 : 0
}

# ── variables.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "compartment_ocid" {}
variable "vcn_id" {}
variable "subnet_name" {}
variable "create_subnet" {
  default     = true
  description = "Creates a new subnet. If false, bypass the creation."
}
variable "cidr_block" {
  default     = ["10.20.0.0/16"]
  description = "IPv4 CIDR Block for the subnet."
}
variable "display_name" {
  default     = null
  description = "Display name for the subnet."
}
variable "dns_label" {
  default     = null
  description = "DNS Label for subnet."
}
variable "prohibit_public_ip_on_vnic" {
  default     = null
  description = "Whether VNICs within this subnet can have public IP addresses. Defaults to false, which means VNICs created in this subnet will automatically be assigned public IP addresses. If `prohibit_public_ip_on_vnic` is set to true, VNICs created in this subnet cannot have public IP addresses (that is, it's a private subnet)."
}
variable "prohibit_internet_ingress" {
  default     = null
  description = "Whether to disallow ingress internet traffic to VNICs within this subnet. prohibitPublicIpOnVnic will be set to the value of prohibitInternetIngress to dictate IPv4 behavior in this subnet. Only one or the other flag should be specified."
}
variable "route_table_id" {
  default     = null
  description = "The OCID of the route table the subnet will use. If you don't specify a route table here, the subnet will use the VCN's default route table. For information about why you would associate a route table with a subnet, see [Transit Routing: Access to Multiple VCNs in Same Region]."
}
variable "dhcp_options_id" {
  default     = null
  description = "The OCID of the set of DHCP options the subnet will use. If you don't specify a set of options, the subnet will use the VCN's default set. For more information about DHCP options, see [Managing DHCP Options]."
}
variable "security_list_ids" {
  default     = null
  description = "The OCID of the set of DHCP options the subnet will use. If you don't specify a set of options, the subnet will use the VCN's default set. For more information about DHCP options, see [Managing DHCP Options]."
}
variable "ipv6cidr_block" {
  default     = null
  description = "IPv6 CIDR Block for the subnet."
}

# Deployment Details + Freeform Tags + Defined Tags
variable "subnet_tags" {
  description = "Tags to be added to the subnet resources"
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "subnet_id" {
  value       = var.create_subnet ? oci_core_subnet.subnet[0].id : null
  description = "The OCID of the subnet."
}
output "subnet_name" {
  value       = var.subnet_name
  description = "The reference name of the subnet. (Not the display name)"
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