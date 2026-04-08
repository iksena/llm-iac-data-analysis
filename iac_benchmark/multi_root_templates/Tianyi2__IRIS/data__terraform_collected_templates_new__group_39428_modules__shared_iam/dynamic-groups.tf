### IAM Dynamic Groups and Users

### CloudScanner Dynamic Groups and Users

# CloudScanner dynamic group - needs tenancy-wide access for resource discovery
# This dynamic group will be attached to CloudScanner Worker Instances and Scaler Functions
resource "oci_identity_dynamic_group" "cloudscanner_dg" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = var.oci_tenancy_id
  name           = format("upwind-cs-%s", local.resource_suffix_hyphen)
  description    = "Dynamic group used by CloudScanners for scanning across compartments and scaling operations"
  # TODO: all compartments for resource discovery, but scanning operations in orchestrator compartment
  matching_rule = "ALL {instance.compartment.id != ''}"
  freeform_tags = local.validated_tags

  lifecycle {
    precondition {
      condition     = length(format("upwind-cs-%s", local.resource_suffix_hyphen)) <= 100
      error_message = "Dynamic group name cannot exceed 100 characters."
    }
    precondition {
      condition     = can(regex("^[a-zA-Z0-9_.-]+$", format("upwind-cs-%s", local.resource_suffix_hyphen)))
      error_message = "Dynamic group name must only contain a-zA-Z0-9_.- characters."
    }
  }
}

### User Resources for Workload Identity Federation

# Create users that dynamic groups can assume for workload identity federation
resource "oci_identity_user" "upwind_management_user" {
  compartment_id = var.oci_tenancy_id
  name           = format("upwind-mgmt-%s", local.resource_suffix_hyphen)
  description    = "User for Upwind management operations - can be assumed by dynamic groups"
  email          = format("upwind-mgmt-%s@noreply.upwind.io", local.resource_suffix_hyphen)
  freeform_tags  = local.validated_tags

  lifecycle {
    precondition {
      condition     = length(format("upwind-mgmt-%s", local.resource_suffix_hyphen)) <= 30
      error_message = "User name cannot exceed 30 characters."
    }
  }
}

resource "oci_identity_user" "upwind_ro_user" {
  compartment_id = var.oci_tenancy_id
  name           = format("upwind-ro-%s", local.resource_suffix_hyphen)
  description    = "User for Upwind reader operations - can be assumed by dynamic groups"
  email          = format("upwind-ro-%s@noreply.upwind.io", local.resource_suffix_hyphen)
  freeform_tags  = local.validated_tags

  lifecycle {
    precondition {
      condition     = length(format("upwind-ro-%s", local.resource_suffix_hyphen)) <= 30
      error_message = "User name cannot exceed 30 characters."
    }
  }
}

resource "oci_identity_user" "cloudscanner_user" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = var.oci_tenancy_id
  name           = format("upwind-cs-%s", local.resource_suffix_hyphen)
  description    = "User for CloudScanner operations - can be assumed by dynamic groups"
  email          = format("upwind-cs-%s@noreply.upwind.io", local.resource_suffix_hyphen)
  freeform_tags  = local.validated_tags

  lifecycle {
    precondition {
      condition     = length(format("upwind-cs-%s", local.resource_suffix_hyphen)) <= 30
      error_message = "User name cannot exceed 30 characters."
    }
  }
}

