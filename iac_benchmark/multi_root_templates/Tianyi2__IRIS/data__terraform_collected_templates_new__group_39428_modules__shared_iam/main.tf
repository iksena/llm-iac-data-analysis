locals {
  compartment_id = var.upwind_orchestrator_compartment_id
  # Sanitize the org_id to be used in resource names
  # Dynamic group names can contain [a-zA-Z0-9_.-] and have a 100 character limit
  # We use hyphens as separators for consistency and readability
  org_id_sanitized = replace(lower(var.upwind_organization_id), "org_", "")

  # Truncate org_id to last 5 characters in lowercase to ensure it fits within resource name limits
  # Keep it reasonably short to leave room for other components
  org_id_truncated = substr(local.org_id_sanitized, length(local.org_id_sanitized) - 5, 5)

  # Create resource suffixes that include both org_id and user-provided suffix
  resource_suffix_hyphen     = format("%s%s", local.org_id_truncated, var.resource_suffix == "" ? "" : "-${var.resource_suffix}")
  resource_suffix_underscore = format("%s%s", local.org_id_truncated, var.resource_suffix == "" ? "" : "_${var.resource_suffix}")

  # Merge default tags with user-provided tags
  # User tags override defaults if keys conflict
  merged_tags = merge(var.default_tags, var.tags)

  # Common validation for tags (supports [a-zA-Z0-9_.-])
  validated_tags = {
    for k, v in local.merged_tags : k => v
    if can(regex("^[a-zA-Z0-9_.-]{1,100}$", k)) && can(regex("^[a-zA-Z0-9_.-]{0,100}$", v))
  }
}

# Get all subscribed regions for the tenancy
data "oci_identity_region_subscriptions" "tenancy_regions" {
  tenancy_id = var.oci_tenancy_id
}
