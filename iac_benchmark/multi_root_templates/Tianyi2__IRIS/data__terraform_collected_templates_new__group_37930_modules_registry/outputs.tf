output "host" {
  value       = var.host
  description = "FQDN pour l'ingress registry"
}

output "tls_secret_name" {
  value       = var.tls_secret_name
  description = "Secret TLS pour l'ingress registry"
}
