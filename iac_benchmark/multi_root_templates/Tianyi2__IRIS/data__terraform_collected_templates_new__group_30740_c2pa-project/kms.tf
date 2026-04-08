# kms.tf

resource "google_kms_key_ring" "keyring" {
  for_each = toset(var.regions)

  name     = "c2pa-ring-${each.key}-${random_id.suffix.hex}"
  location = each.key #var.multi_region_location
  project  = var.project_id

    depends_on = [
    google_project_service.apis["cloudkms.googleapis.com"]
  ]
}

resource "google_kms_crypto_key" "signing_key" {
  for_each = toset(var.regions)
  name            = "c2pa-signing-key-${each.key}"
  key_ring        = google_kms_key_ring.keyring[each.key].id
  purpose         = "ASYMMETRIC_SIGN"
  version_template {
    algorithm = "EC_SIGN_P256_SHA256"
    protection_level = "HSM"
  }
  destroy_scheduled_duration = "86400s" # 24 hours
}

# TODO: upgrade to using key_versions in future; currently (11/25) there's a TF provider bug preventing usage of it
#resource "google_kms_crypto_key_version" "signing_key_version" {
#  for_each = toset(var.regions)  
#  crypto_key = google_kms_crypto_key.signing_key[each.key].id
#}