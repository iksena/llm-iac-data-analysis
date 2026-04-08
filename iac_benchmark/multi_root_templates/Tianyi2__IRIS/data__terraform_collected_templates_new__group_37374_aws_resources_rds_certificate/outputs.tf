# This resource exports no additional attributes according to the documentation
# Only the implicit attributes (id, etc.) are available

output "id" {
  description = "The ID of the RDS certificate override (typically the region)"
  value       = aws_rds_certificate.this.id
}