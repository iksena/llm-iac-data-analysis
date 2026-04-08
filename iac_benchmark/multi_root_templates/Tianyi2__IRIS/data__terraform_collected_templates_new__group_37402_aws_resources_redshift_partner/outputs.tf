output "id" {
  description = "The identifier of the Redshift partner, account_id, cluster_identifier, database_name, partner_name separated by a colon (:)."
  value       = aws_redshift_partner.this.id
}

output "status" {
  description = "The partner integration status."
  value       = aws_redshift_partner.this.status
}

output "status_message" {
  description = "The status message provided by the partner."
  value       = aws_redshift_partner.this.status_message
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_redshift_partner.this.region
}

output "account_id" {
  description = "The Amazon Web Services account ID that owns the cluster."
  value       = aws_redshift_partner.this.account_id
}

output "cluster_identifier" {
  description = "The cluster identifier of the cluster that receives data from the partner."
  value       = aws_redshift_partner.this.cluster_identifier
}

output "database_name" {
  description = "The name of the database that receives data from the partner."
  value       = aws_redshift_partner.this.database_name
}

output "partner_name" {
  description = "The name of the partner that is authorized to send data."
  value       = aws_redshift_partner.this.partner_name
}