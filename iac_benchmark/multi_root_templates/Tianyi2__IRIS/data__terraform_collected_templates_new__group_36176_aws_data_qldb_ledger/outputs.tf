output "name" {
  description = "Friendly name of the ledger"
  value       = data.aws_qldb_ledger.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_qldb_ledger.this.region
}

output "arn" {
  description = "The Amazon Resource Name (ARN) for the ledger"
  value       = data.aws_qldb_ledger.this.arn
}

output "deletion_protection" {
  description = "Deletion protection flag for the ledger"
  value       = data.aws_qldb_ledger.this.deletion_protection
}

output "kms_key" {
  description = "The KMS key used for encryption of data at rest in the ledger"
  value       = data.aws_qldb_ledger.this.kms_key
}

output "permissions_mode" {
  description = "The permissions mode of the ledger"
  value       = data.aws_qldb_ledger.this.permissions_mode
}

output "tags" {
  description = "Tags associated with the ledger"
  value       = data.aws_qldb_ledger.this.tags
}