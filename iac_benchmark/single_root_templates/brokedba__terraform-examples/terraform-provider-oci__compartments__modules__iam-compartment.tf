# ── main.tf ────────────────────────────────────
// Copyright (c) 2018, 2021, Oracle and/or its affiliates.
 

########################
# Compartment
########################

resource "oci_identity_compartment" "this" {
  count          = var.compartment_create ? 1 : 0
  compartment_id = var.compartment_id != null ? var.compartment_id : var.tenancy_ocid
  name           = var.compartment_name
  description    = var.compartment_description
  enable_delete  = var.enable_delete
}

data "oci_identity_compartments" "this" {
  count          = var.compartment_create ? 0 : 1
  compartment_id = var.compartment_id

  filter {
    name   = "name"
    values = [var.compartment_name]
  }
}

locals {
  compartment_ids        = concat(flatten(data.oci_identity_compartments.this.*.compartments), tolist( [tomap({"id" = ""})]))
  parent_compartment_ids = concat(flatten(data.oci_identity_compartments.this.*.compartments), tolist([tomap({"compartment_id" = ""})]))
}


# ── variables.tf ────────────────────────────────────
// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

variable "tenancy_ocid" {
  type = string
  description = "(Deprecated) The OCID of the tenancy."
  default = null
}

variable "compartment_id" {
  type = string
  description = "The OCID of the parent compartment containing the compartment. Allow for sub-compartments creation"
  default     = null
}

variable "compartment_name" {
  type = string
  description = "The name you assign to the compartment during creation. The name must be unique across all compartments in the tenancy. "
  default     = null
}

// The description is only used if compartment_create = true.
variable "compartment_description" {
  type = string
  description = "The description you assign to the compartment. Does not have to be unique, and it's changeable. "
  default     = null
}

variable "compartment_create" {
  type = bool
  description = "(Deprecated) Create the compartment or not. If true, the compartment will be managed by this module, and the user must have permissions to create the compartment; If false, compartment data will be returned about the compartment if it exists, if not found, then an empty string will be returned for the compartment ID."
  default     = true
}

variable "enable_delete" {
  type = bool
  description = "Enable compartment delete on destroy. If true, compartment will be deleted when `terraform destroy` is executed; If false, compartment will not be deleted on `terraform destroy` execution"
  default     = false
}


# ── versions.tf ────────────────────────────────────
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">=4.67.3"
    }
  }
  required_version = ">= 1.0.0"
}


# ── output.tf ────────────────────────────────────
output "compartment_id" {
  description = "Compartment ocid"
  // This allows the compartment ID to be retrieved from the resource if it exists, and if not to use the data source.
  value = var.compartment_create ? element(concat(oci_identity_compartment.this.*.id, tolist([""])), 0) : lookup(local.compartment_ids[0], "id")
}

output "parent_compartment_id" {
  description = "Parent Compartment ocid"
  // This allows the compartment ID to be retrieved from the resource if it exists, and if not to use the data source.
  value = var.compartment_create ? element(concat(oci_identity_compartment.this.*.compartment_id, tolist([""])), 0) : lookup(local.parent_compartment_ids[0], "compartment_id")
}

output "compartment_name" {
  description = "Compartment name"
  value = var.compartment_name
}

output "compartment_description" {
  description = "Compartment description"
  value = var.compartment_description
}

/*
output "level_1_sub_compartments" {
  description = "compartment name, description, ocid, and parent ocid"
  value = {
    name        = module.level_1_sub_compartments.compartment_name,
    description = module.level_1_sub_compartments.compartment_description,
    ocid        = module.level_1_sub_compartments.compartment_id,
    parent      = module.level_1_sub_compartments.parent_compartment_id
  }
}

output "level_2_sub_compartments" {
  description = "compartment name, description, ocid, and parent ocid"
  value = {
    name        = module.level_2_sub_compartments.compartment_name,
    description = module.level_2_sub_compartments.compartment_description,
    ocid        = module.level_2_sub_compartments.compartment_id,
    parent      = module.level_2_sub_compartments.parent_compartment_id
  }
}
*/