output "id" {
  description = "The Name of the QLDB Ledger"
  value       = aws_qldb_ledger.this.id
}

output "arn" {
  description = "The ARN of the QLDB Ledger"
  value       = aws_qldb_ledger.this.arn
}

output "name" {
  description = "The friendly name for the QLDB Ledger instance"
  value       = aws_qldb_ledger.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_qldb_ledger.this.region
}

output "deletion_protection" {
  description = "The deletion protection status for the QLDB Ledger instance"
  value       = aws_qldb_ledger.this.deletion_protection
}

output "kms_key" {
  description = "The KMS key used for encryption of data at rest in the ledger"
  value       = aws_qldb_ledger.this.kms_key
}

output "permissions_mode" {
  description = "The permissions mode for the QLDB ledger instance"
  value       = aws_qldb_ledger.this.permissions_mode
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = aws_qldb_ledger.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_qldb_ledger.this.tags_all
}