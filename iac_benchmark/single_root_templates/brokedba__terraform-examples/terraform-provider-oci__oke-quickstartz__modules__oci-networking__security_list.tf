# ── main.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_core_security_list" "security_list" {
  compartment_id = var.compartment_ocid
  display_name   = var.display_name
  vcn_id         = var.vcn_id
  freeform_tags  = var.security_list_tags.freeformTags
  defined_tags   = var.security_list_tags.definedTags

  dynamic "egress_security_rules" {
    for_each = var.egress_security_rules
    content {
      description      = egress_security_rules.value.description
      destination      = egress_security_rules.value.destination
      destination_type = egress_security_rules.value.destination_type
      protocol         = egress_security_rules.value.protocol
      stateless        = egress_security_rules.value.stateless

      dynamic "tcp_options" {
        for_each = (egress_security_rules.value.tcp_options.max != -1 && egress_security_rules.value.tcp_options.min != -1) ? [1] : []
        content {
          max = egress_security_rules.value.tcp_options.max
          min = egress_security_rules.value.tcp_options.min
          dynamic "source_port_range" {
            for_each = can(egress_security_rules.value.tcp_options.source_port_range.max) ? [1] : []
            content {
              max = egress_security_rules.value.tcp_options.source_port_range.max
              min = egress_security_rules.value.tcp_options.source_port_range.min
            }
          }
        }
      }
      dynamic "udp_options" {
        for_each = (egress_security_rules.value.udp_options.max != -1 && egress_security_rules.value.udp_options.min != -1) ? [1] : []
        content {
          max = egress_security_rules.value.udp_options.max
          min = egress_security_rules.value.udp_options.min
          dynamic "source_port_range" {
            for_each = can(egress_security_rules.value.udp_options.source_port_range.max) ? [1] : []
            content {
              max = egress_security_rules.value.udp_options.source_port_range.max
              min = egress_security_rules.value.udp_options.source_port_range.min
            }
          }
        }
      }
      dynamic "icmp_options" {
        for_each = can(egress_security_rules.value.icmp_options.type) ? [1] : []
        content {
          type = egress_security_rules.value.icmp_options.type
          code = egress_security_rules.value.icmp_options.code
        }
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.ingress_security_rules
    content {
      description = ingress_security_rules.value.description
      source      = ingress_security_rules.value.source
      source_type = ingress_security_rules.value.source_type
      protocol    = ingress_security_rules.value.protocol
      stateless   = ingress_security_rules.value.stateless

      dynamic "tcp_options" {
        for_each = (ingress_security_rules.value.tcp_options.max != -1 && ingress_security_rules.value.tcp_options.min != -1) ? [1] : []
        content {
          max = ingress_security_rules.value.tcp_options.max
          min = ingress_security_rules.value.tcp_options.min
          dynamic "source_port_range" {
            for_each = can(ingress_security_rules.value.tcp_options.source_port_range.max) ? [1] : []
            content {
              max = ingress_security_rules.value.tcp_options.source_port_range.max
              min = ingress_security_rules.value.tcp_options.source_port_range.min
            }
          }
        }
      }
      dynamic "udp_options" {
        for_each = (ingress_security_rules.value.udp_options.max != -1 && ingress_security_rules.value.udp_options.min != -1) ? [1] : []
        content {
          max = ingress_security_rules.value.udp_options.max
          min = ingress_security_rules.value.udp_options.min
          dynamic "source_port_range" {
            for_each = can(ingress_security_rules.value.udp_options.source_port_range.max) ? [1] : []
            content {
              max = ingress_security_rules.value.udp_options.source_port_range.max
              min = ingress_security_rules.value.udp_options.source_port_range.min
            }
          }
        }
      }
      dynamic "icmp_options" {
        for_each = can(ingress_security_rules.value.icmp_options.type) ? [1] : []
        content {
          type = ingress_security_rules.value.icmp_options.type
          code = ingress_security_rules.value.icmp_options.code
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [freeform_tags, defined_tags, egress_security_rules, ingress_security_rules]
  }

  count = var.create_security_list ? 1 : 0
}

# ── variables.tf ────────────────────────────────────
# Copyright (c) 2022, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

variable "compartment_ocid" {}
variable "vcn_id" {}
variable "security_list_name" {}
variable "create_security_list" {
  default     = false
  description = "Creates a new security list. If false, bypass the creation."
}
variable "display_name" {
  default     = null
  description = "Display name for the security list."
}
variable "egress_security_rules" {
  type = list(object({
    description      = string
    destination      = string
    destination_type = string
    protocol         = string
    stateless        = bool
    tcp_options = object({
      max = number
      min = number
      source_port_range = object({
        max = number
        min = number
      })
    })
    udp_options = object({
      max = number
      min = number
      source_port_range = object({
        max = number
        min = number
      })
    })
    icmp_options = object({
      type = number
      code = number
    })
  }))
  default = []
}

variable "ingress_security_rules" {
  type = list(object({
    description = string
    source      = string
    source_type = string
    protocol    = string
    stateless   = bool
    tcp_options = object({
      max = number
      min = number
      source_port_range = object({
        max = number
        min = number
      })
    })
    udp_options = object({
      max = number
      min = number
      source_port_range = object({
        max = number
        min = number
      })
    })
    icmp_options = object({
      type = number
      code = number
    })
  }))
  default = []
}

# variable "egress_security_rules" {
#   type = list(object({
#     description      = optional(string)
#     destination      = string
#     destination_type = optional(string)
#     protocol         = string
#     stateless        = optional(bool)
#     tcp_options = optional(object({
#       max = optional(number)
#       min = optional(number)
#       source_port_range = optional(object({
#         max = number
#         min = number
#       }))
#     }))
#     udp_options = optional(object({
#       max = optional(number)
#       min = optional(number)
#       source_port_range = optional(object({
#         max = number
#         min = number
#       }))
#     }))
#     icmp_options = optional(object({
#       type = number
#       code = optional(number)
#     }))
#   }))
#   default = []
# }
# variable "ingress_security_rules" {
#   type = list(object({
#     description = optional(string)
#     source      = string
#     source_type = optional(string)
#     protocol    = string
#     stateless   = optional(bool)
#     tcp_options = optional(object({
#       max = optional(number)
#       min = optional(number)
#       source_port_range = optional(object({
#         max = number
#         min = number
#       }))
#     }))
#     udp_options = optional(object({
#       max = optional(number)
#       min = optional(number)
#       source_port_range = optional(object({
#         max = number
#         min = number
#       }))
#     }))
#     icmp_options = optional(object({
#       type = number
#       code = optional(number)
#     }))
#   }))
#   default = []
# }

# Deployment Details + Freeform Tags + Defined Tags
variable "security_list_tags" {
  description = "Tags to be added to the security list resources"
}

# ── outputs.tf ────────────────────────────────────
# Copyright (c) 2022 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

output "security_list_id" {
  value       = var.create_security_list ? oci_core_security_list.security_list[0].id : null
  description = "The OCID of the security list."
}
output "security_list_name" {
  value       = var.security_list_name
  description = "The reference name of the security list. (Not the display name)"
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
  # experiments = [module_variable_optional_attrs]
}