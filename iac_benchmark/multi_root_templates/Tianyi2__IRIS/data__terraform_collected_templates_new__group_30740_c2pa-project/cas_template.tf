# cas_template.tf

resource "google_privateca_certificate_template" "c2pa_leaf" {
  for_each = toset(var.regions)

  name        = "c2pa-tmpl-${each.key}-${random_id.suffix.hex}"
  location    = each.key
  project     = var.project_id
  description = "Enforces C2PA X.509 requirements: Digital Signature, Non-Repudiation, and Email Protection EKU."

  # C2PA Requirement: This is an End-Entity (Leaf) certificate, not a CA.
  predefined_values {
    ca_options {
      is_ca = false
    }

    # C2PA Requirement: Key Usage MUST include Digital Signature.
    # Content Commitment (Non-Repudiation) is strongly recommended.
    key_usage {
      base_key_usage {
        digital_signature  = true
        content_commitment = true # "Non-repudiation"
        cert_sign          = false
        crl_sign           = false
      }

      # C2PA Requirement: Must have at least one EKU (Email Protection or Document Signing).
      # "email_protection" is the standard fallback supported by most C2PA validators.
      extended_key_usage {
        email_protection = true
        server_auth      = false
        client_auth      = false
        code_signing     = false
        time_stamping    = false
      }
    }
  }

  # Allow the Python script to supply the Subject (Author Name) and Public Key.
  identity_constraints {
    allow_subject_passthrough           = true
    allow_subject_alt_names_passthrough = false # Strict identity control
    
    # Do not allow the script to override Key Usage (enforced by this template)
    cel_expression {
      description = "Ensure Subject Common Name is set"
      expression  = "subject.common_name.size() > 0"
    }
  }

  depends_on = [
    google_project_service.apis["privateca.googleapis.com"]
  ]
}