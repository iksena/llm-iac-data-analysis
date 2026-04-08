output "id" {
  description = "Identifier of the source cluster (use cluster_identifier instead as this is deprecated)"
  value       = aws_redshift_logging.this.id
}

output "cluster_identifier" {
  description = "Identifier of the source cluster"
  value       = aws_redshift_logging.this.cluster_identifier
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_redshift_logging.this.region
}

output "bucket_name" {
  description = "Name of the S3 bucket where the log files are stored"
  value       = aws_redshift_logging.this.bucket_name
}

output "log_destination_type" {
  description = "Log destination type"
  value       = aws_redshift_logging.this.log_destination_type
}

output "log_exports" {
  description = "Collection of exported log types"
  value       = aws_redshift_logging.this.log_exports
}

output "s3_key_prefix" {
  description = "Prefix applied to the log file names"
  value       = aws_redshift_logging.this.s3_key_prefix
}