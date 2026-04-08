output "enabled" {
  description = "Whether or not default EBS encryption is enabled. Returns as true or false."
  value       = data.aws_ebs_encryption_by_default.this.enabled
}

output "id" {
  description = "Region of default EBS encryption."
  value       = data.aws_ebs_encryption_by_default.this.id
}