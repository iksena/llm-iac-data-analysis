# Cloudflare Resume Website Infrastructure
# This Terraform configuration creates a complete serverless website with authentication
# Architecture: Cloudflare Pages + Workers + D1 Database + R2 Storage
# Documentation: https://developers.cloudflare.com/terraform/

# Terraform configuration block - defines required providers and versions
# Documentation: https://developer.hashicorp.com/terraform/language/settings
terraform {
  required_providers {
    # Cloudflare Provider for managing Cloudflare resources
    # Documentation: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Configure the Cloudflare Provider
# Authentication via CLOUDFLARE_API_TOKEN environment variable
# Documentation: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs#authentication
# Create token at: https://dash.cloudflare.com/profile/api-tokens
# Required permissions: Zone:Read, DNS:Edit, Account:Read, Pages:Edit, Workers:Edit, D1:Edit, R2:Edit
provider "cloudflare" {
  # API token is read from CLOUDFLARE_API_TOKEN environment variable
  # Set with: export CLOUDFLARE_API_TOKEN="your-token-here"
}

# Data source to get zone information for DNS management
# This retrieves existing zone details for the domain (domain must already exist in Cloudflare)
# Documentation: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone
data "cloudflare_zone" "main" {
  name = var.domain_name  # Domain name from variables.tf
}

# Cloudflare Pages project for hosting the static website
# Pages provides global CDN, automatic HTTPS, and serverless hosting
# Documentation: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/pages_project
# Cloudflare Pages Guide: https://developers.cloudflare.com/pages/
resource "cloudflare_pages_project" "resume_site" {
  account_id        = var.cloudflare_account_id
  name              = "resumecloudflare"  # Must be unique across Cloudflare
  production_branch = "main"              # Git branch for production deployments

  # Build configuration for static site generation
  # Documentation: https://developers.cloudflare.com/pages/configuration/build-configuration/
  build_config {
    build_command   = "npm run build"  # Command to build the site
    destination_dir = "public"          # Directory containing built files
  }

  # Direct upload mode (no Git integration)
  # For Git integration, uncomment and configure:
  # source {
  #   type = "github"
  #   config {
  #     owner = "your-username"
  #     repo_name = "your-repo"
  #     production_branch = "main"
  #   }
  # }

  # Environment-specific configuration
  # Documentation: https://developers.cloudflare.com/pages/configuration/
  deployment_configs {
    production {
      environment_variables = {
        NODE_VERSION = "18"  # Node.js version for build process
      }
    }
  }
}

# Custom domains for the Pages project
# These resources attach custom domains to the Pages project and handle SSL certificates
# Documentation: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/pages_domain
# Custom Domains Guide: https://developers.cloudflare.com/pages/configuration/custom-domains/
resource "cloudflare_pages_domain" "resume_domain" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.resume_site.name
  domain       = var.domain_name  # Root domain (e.g., example.com)
}

resource "cloudflare_pages_domain" "resume_domain_www" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.resume_site.name
  domain       = "www.${var.domain_name}"  # WWW subdomain (e.g., www.example.com)
}

# DNS records for custom domains
# These CNAME records point your domain to the Pages project
# Documentation: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record
# DNS Records Guide: https://developers.cloudflare.com/dns/manage-dns-records/
resource "cloudflare_record" "root_domain" {
  zone_id = data.cloudflare_zone.main.id
  name    = var.domain_name  # Root domain
  content = "${cloudflare_pages_project.resume_site.name}.pages.dev"  # Points to Pages project
  type    = "CNAME"          # CNAME record type
  proxied = true             # Enable Cloudflare proxy (CDN, security, etc.)
}

resource "cloudflare_record" "www_domain" {
  zone_id = data.cloudflare_zone.main.id
  name    = "www"            # WWW subdomain
  content = "${cloudflare_pages_project.resume_site.name}.pages.dev"  # Points to Pages project
  type    = "CNAME"          # CNAME record type
  proxied = true             # Enable Cloudflare proxy (CDN, security, etc.)
}

# Automated deployment using wrangler CLI
# This null resource runs wrangler to deploy the site after Pages project creation
# Documentation: https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource
# Wrangler CLI Guide: https://developers.cloudflare.com/workers/wrangler/
resource "null_resource" "deploy_site" {
  depends_on = [cloudflare_pages_project.resume_site]  # Wait for Pages project
  
  # Local execution provisioner runs wrangler deploy command
  # Documentation: https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec
  provisioner "local-exec" {
    command = "wrangler pages deploy public --project-name ${cloudflare_pages_project.resume_site.name}"
    working_dir = "${path.module}/.."  # Run from project root directory
  }
  
  # Triggers determine when to re-run the deployment
  # This will redeploy when index.html changes
  triggers = {
    files_hash = filemd5("${path.module}/../public/index.html")
  }
}

# D1 Database for user authentication and application data
# D1 is Cloudflare's serverless SQL database built on SQLite
# Documentation: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/d1_database
# D1 Guide: https://developers.cloudflare.com/d1/
resource "cloudflare_d1_database" "auth_db" {
  account_id = var.cloudflare_account_id
  name       = "resume-auth-db"  # Database name (must be unique in account)
}

# R2 Bucket for storing photos, documents, and static assets
# R2 is Cloudflare's S3-compatible object storage
# Documentation: https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/r2_bucket
# R2 Guide: https://developers.cloudflare.com/r2/
resource "cloudflare_r2_bucket" "assets_bucket" {
  account_id = var.cloudflare_account_id
  name       = "resume-assets"  # Bucket name (must be globally unique)
  location   = "WNAM"           # Western North America region
}

# Random ID for generating unique identifiers
# Used for creating unique resource names when needed
# Documentation: https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id
resource "random_id" "bucket_suffix" {
  byte_length = 4  # Generates 8-character hex string
}