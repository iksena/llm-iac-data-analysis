# ── main.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = var.display_name
  freeform_tags  = var.route_table_tags.freeformTags
  defined_tags   = var.route_table_tags.definedTags

  dynamic "route_rules" {
    for_each = var.route_rules
    content {
      description       = route_rules.value.description
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      network_entity_id = route_rules.value.network_entity_id
    }
  }

  count = var.create_route_table ? 1 : 0
}

# ── variables.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "compartment_ocid" {}
variable "vcn_id" {}
variable "route_table_name" {}
variable "create_route_table" {
  default     = false
  description = "Creates a new route table. If false, bypass the creation."
}
variable "display_name" {
  default     = null
  description = "Display name for the subnet."
}
variable "route_rules" {
  type = list(object({
    description       = string
    destination       = string
    destination_type  = string
    network_entity_id = string
  }))
  default = []
}
# Deployment Details + Freeform Tags + Defined Tags
variable "route_table_tags" {
  description = "Tags to be added to the route table resources"
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "route_table_id" {
  value       = var.create_route_table ? oci_core_route_table.route_table[0].id : null
  description = "The OCID of the Route Table."
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