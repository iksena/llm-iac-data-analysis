### Vault and Vault Key Resources

# Data source for existing vault when oci_vault_id is provided
data "oci_kms_vault" "existing_vault" {
  count    = var.oci_vault_id != "" ? 1 : 0
  vault_id = var.oci_vault_id
}

# Data source for existing vault key when oci_vault_key_id is provided
# Note: When using an existing vault, we need the management_endpoint from the vault
data "oci_kms_key" "existing_vault_key" {
  count               = var.oci_vault_key_id != "" && var.oci_vault_id != "" ? 1 : 0
  key_id              = var.oci_vault_key_id
  management_endpoint = data.oci_kms_vault.existing_vault[0].management_endpoint
}

# Create the Vault for storing secrets (only if oci_vault_id is not provided)
resource "oci_kms_vault" "upwind_vault" {
  count          = var.oci_vault_id == "" ? 1 : 0
  compartment_id = local.compartment_id
  display_name   = format("upwind-vault-%s", local.resource_suffix_hyphen)
  # Required for software-only keys
  vault_type    = "DEFAULT"
  freeform_tags = local.validated_tags
}

# Create the Vault Key for encryption when using a newly created vault
resource "oci_kms_key" "upwind_vault_key" {
  count               = var.oci_vault_key_id == "" && var.oci_vault_id == "" ? 1 : 0
  compartment_id      = local.compartment_id
  display_name        = format("upwind-vault-key-%s", local.resource_suffix_hyphen)
  management_endpoint = oci_kms_vault.upwind_vault[0].management_endpoint
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  # Required for software-only keys
  protection_mode = "SOFTWARE"
  freeform_tags   = local.validated_tags
}

# Create the Vault Key for encryption when using an existing vault but no key provided
resource "oci_kms_key" "upwind_vault_key_existing_vault" {
  count               = var.oci_vault_key_id == "" && var.oci_vault_id != "" ? 1 : 0
  compartment_id      = local.compartment_id
  display_name        = format("upwind-vault-key-%s", local.resource_suffix_hyphen)
  management_endpoint = data.oci_kms_vault.existing_vault[0].management_endpoint
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  # Required for software-only keys
  protection_mode = "SOFTWARE"
  freeform_tags   = local.validated_tags
}

# Local values to determine which vault and key to use
locals {
  vault_id = var.oci_vault_id != "" ? var.oci_vault_id : oci_kms_vault.upwind_vault[0].id
  key_id   = var.oci_vault_key_id != "" ? var.oci_vault_key_id : (var.oci_vault_id != "" ? oci_kms_key.upwind_vault_key_existing_vault[0].id : oci_kms_key.upwind_vault_key[0].id)
}

### Secrets used by Cloudscanners

resource "oci_vault_secret" "upwind_client_id" {
  compartment_id = local.compartment_id
  vault_id       = local.vault_id
  key_id         = local.key_id
  secret_name    = "upwind-client-id-${local.resource_suffix_hyphen}"
  secret_content {
    content      = base64encode(var.upwind_client_id)
    content_type = "BASE64"
  }
  description   = "Upwind client ID for authentication"
  freeform_tags = local.validated_tags
}

resource "oci_vault_secret" "upwind_client_secret" {
  compartment_id = local.compartment_id
  vault_id       = local.vault_id
  key_id         = local.key_id
  secret_name    = "upwind-client-secret-${local.resource_suffix_hyphen}"
  secret_content {
    content      = base64encode(var.upwind_client_secret)
    content_type = "BASE64"
  }
  description   = "Upwind client secret for authentication"
  freeform_tags = local.validated_tags
}

resource "oci_vault_secret" "scanner_client_id" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = local.compartment_id
  vault_id       = local.vault_id
  key_id         = local.key_id
  secret_name    = "upwind-scanner-client-id-${local.resource_suffix_hyphen}"
  secret_content {
    content      = base64encode(var.scanner_client_id)
    content_type = "BASE64"
  }
  description   = "Upwind scanner client ID for authentication"
  freeform_tags = local.validated_tags
}

resource "oci_vault_secret" "scanner_client_secret" {
  count          = var.enable_cloudscanners ? 1 : 0
  compartment_id = local.compartment_id
  vault_id       = local.vault_id
  key_id         = local.key_id
  secret_name    = "upwind-scanner-client-secret-${local.resource_suffix_hyphen}"
  secret_content {
    content      = base64encode(var.scanner_client_secret)
    content_type = "BASE64"
  }
  description   = "Upwind scanner client secret for authentication"
  freeform_tags = local.validated_tags
}

# Create an empty secret but apply the user-defined tags to the resource
resource "oci_vault_secret" "terraform_tags" {
  compartment_id = local.compartment_id
  vault_id       = local.vault_id
  key_id         = local.key_id
  secret_name    = "upwind-default-tags-${local.resource_suffix_hyphen}"
  secret_content {
    content      = base64encode("tags-stored-as-resource-metadata")
    content_type = "BASE64"
  }
  description   = "Default tags stored as resource metadata"
  freeform_tags = local.validated_tags
}
