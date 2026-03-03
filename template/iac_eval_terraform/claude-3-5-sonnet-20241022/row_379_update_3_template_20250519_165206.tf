provider "aws" {
  region = "us-east-1"
}

# Create Glacier Vault
resource "aws_glacier_vault" "archive_vault" {
  name = "long-term-archive-vault"

  tags = {
    Environment = "Production"
    Purpose     = "Long-term archival storage"
  }
}

# Output the Vault ARN
output "glacier_vault_arn" {
  value       = aws_glacier_vault.archive_vault.arn
  description = "The ARN of the created Glacier vault"
}