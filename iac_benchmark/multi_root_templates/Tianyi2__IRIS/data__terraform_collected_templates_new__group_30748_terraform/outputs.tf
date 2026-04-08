# Outputs provide important information after Terraform runs
# These values will be displayed and can be used by other systems

output "website_url" {
  description = "URL of the deployed website"
  value       = "https://${var.domain_name}"
}

output "api_url" {
  description = "URL of the API endpoint"
  value       = "https://api.${var.domain_name}"
}

output "pages_project_name" {
  description = "Name of the Cloudflare Pages project"
  value       = cloudflare_pages_project.resume_site.name
}

output "d1_database_id" {
  description = "ID of the D1 database"
  value       = cloudflare_d1_database.auth_db.id
}

output "r2_bucket_name" {
  description = "Name of the R2 bucket"
  value       = cloudflare_r2_bucket.assets_bucket.name
}

output "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for your domain"
  value       = data.cloudflare_zone.main.id
}