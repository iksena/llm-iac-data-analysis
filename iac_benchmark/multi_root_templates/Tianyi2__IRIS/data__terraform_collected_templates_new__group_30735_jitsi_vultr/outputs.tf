# https://developer.hashicorp.com/terraform/language/values/outputs

output "server_url" {
  description = "The URL for accessing the Jitsi Meet web application."
  value       = "https://${local.subdomain}"
}
