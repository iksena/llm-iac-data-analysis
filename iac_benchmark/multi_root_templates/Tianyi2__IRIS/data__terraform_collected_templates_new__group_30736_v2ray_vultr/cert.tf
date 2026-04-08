# https://registry.terraform.io/providers/vancluever/acme/latest/docs
provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

# https://registry.terraform.io/providers/vancluever/acme/latest/docs
provider "acme" {
  alias      = "staging"
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
resource "tls_private_key" "cert" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

# https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/registration
resource "acme_registration" "cert" {
  provider = acme.staging

  account_key_pem = tls_private_key.cert.private_key_pem
  email_address   = var.acme_email
}

# https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate
resource "acme_certificate" "cert" {
  provider = acme.staging

  account_key_pem           = acme_registration.cert.account_key_pem
  common_name               = local.subdomain
  subject_alternative_names = []

  # https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate#using-dns-challenges
  # https://registry.terraform.io/providers/vancluever/acme/latest/docs/guides/dns-providers-cloudflare
  dns_challenge {
    provider = "cloudflare"
    config = {
      CLOUDFLARE_DNS_API_TOKEN = var.cloudflare_api_token
    }
  }
}
