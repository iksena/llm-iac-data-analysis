# Variables for Terraform configuration
# These allow you to customize the deployment without changing the main code

variable "cloudflare_account_id" {
  description = "Your Cloudflare account ID"
  type        = string
  # You can find this in your Cloudflare dashboard sidebar
}

variable "domain_name" {
  description = "Your domain name (e.g., yourname.com)"
  type        = string
  # This should be a domain you own and have added to Cloudflare
}

variable "github_username" {
  description = "Your GitHub username"
  type        = string
}

variable "github_repo_name" {
  description = "GitHub repository name for this project"
  type        = string
  default     = "resume-website"
}

variable "jwt_secret" {
  description = "Secret key for JWT token signing"
  type        = string
  sensitive   = true
  # Generate a strong random string for this
}

variable "admin_email" {
  description = "Admin email for initial setup"
  type        = string
  default     = "admin@example.com"
}