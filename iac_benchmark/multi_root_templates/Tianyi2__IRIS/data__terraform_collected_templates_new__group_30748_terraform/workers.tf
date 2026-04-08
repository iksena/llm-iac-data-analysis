# Cloudflare Workers for API endpoints and authentication
# Workers run serverless JavaScript at the edge

# Worker script for authentication API
resource "cloudflare_workers_script" "auth_api" {
  account_id = var.cloudflare_account_id
  name       = "resume-website-terraform"
  content    = file("${path.module}/../src/worker-simple.js")
  module     = true

  # D1 and R2 bindings managed separately
  # d1_database_binding {
  #   name        = "DB"
  #   database_id = "cca03fd3-c5dc-4e39-b7bb-d1d2a901bdec"
  # }
  #
  # r2_bucket_binding {
  #   name        = "BUCKET"
  #   bucket_name = "resume-assets"
  # }

  # Environment variables for the worker
  plain_text_binding {
    name = "JWT_SECRET"
    text = var.jwt_secret
  }

  plain_text_binding {
    name = "ADMIN_EMAIL"
    text = var.admin_email
  }
}

# Worker domain and route managed separately with wrangler
# resource "cloudflare_worker_domain" "api_domain" {
#   account_id = var.cloudflare_account_id
#   hostname   = "api.${var.domain_name}"
#   service    = cloudflare_workers_script.auth_api.name
#   zone_id    = data.cloudflare_zone.main.id
# }
#
# resource "cloudflare_worker_route" "api_route" {
#   zone_id     = data.cloudflare_zone.main.id
#   pattern     = "api.${var.domain_name}/*"
#   script_name = cloudflare_workers_script.auth_api.name
# }