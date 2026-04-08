output "id" {
  description = "The ID of the EBS encryption by default setting"
  value       = aws_ebs_encryption_by_default.this.id
}

output "region" {
  description = "The region where EBS encryption by default is configured"
  value       = aws_ebs_encryption_by_default.this.region
}

output "enabled" {
  description = "Whether default EBS encryption is enabled"
  value       = aws_ebs_encryption_by_default.this.enabled
}