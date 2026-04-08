# cas.tf

resource "google_privateca_ca_pool" "pool" {
  for_each = toset(var.regions)

  name     = "c2pa-ca-pool-${each.key}-${random_id.suffix.hex}"
  location = each.key
  tier     = "ENTERPRISE"
  project  = var.project_id
  
    depends_on = [
    google_project_service.apis["privateca.googleapis.com"]
  ]
}

# We need to fetch the email identity of the Google-managed CAS Service Agent
resource "google_project_service_identity" "privateca_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "privateca.googleapis.com"
}

# Grant the CAS Service Agent permission to sign using the KMS key
resource "google_kms_crypto_key_iam_member" "cas_signer_binding" {
  for_each = toset(var.regions)

  crypto_key_id = google_kms_crypto_key.signing_key[each.key].id
  role          = "roles/cloudkms.signerVerifier"
  member        = "serviceAccount:${google_project_service_identity.privateca_sa.email}"
}

resource "google_privateca_certificate_authority" "regional_ca" {
  for_each = toset(var.regions)

  pool                     = google_privateca_ca_pool.pool[each.key].name
  certificate_authority_id = "c2pa-ca-${each.value}"
  location                 = each.value # Create a CA in each region
  project                  = var.project_id
  type                     = "SELF_SIGNED" # CHANGE: For production, change to SUBORDINATE
  
  # For production, you would create a self-signed root CA separately and have
  # these subordinates chained to it. For this example, we make them self-signed for simplicity.
  # In a true subordinate setup, you'd define a `subordinate_config` block.
  config {
    subject_config {
      subject {
        organization = "${var.c2pa_author_name}"
        common_name  = "C2PA Regional CA ${each.value}"
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign  = true
          digital_signature = true
          content_commitment = true
          }
    extended_key_usage {
      email_protection = true
      }
      }
    }
  }
  key_spec {
    algorithm = "EC_P256_SHA256"
  }
  
  deletion_protection                    = false
  skip_grace_period                      = true
  ignore_active_certificates_on_deletion = true
  lifetime = "${365 * 24 * 3600}s" # 1 year

  # Ensure the pool exists before creating the CA
  depends_on = [
    google_privateca_ca_pool.pool,
    google_kms_crypto_key_iam_member.cas_signer_binding
  ]
}
