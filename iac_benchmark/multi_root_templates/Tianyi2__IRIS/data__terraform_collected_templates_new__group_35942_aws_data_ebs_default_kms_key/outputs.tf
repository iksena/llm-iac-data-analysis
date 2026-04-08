output "key_arn" {
  description = "ARN of the default KMS key uses to encrypt an EBS volume in this region when no key is specified in an API call that creates the volume and encryption by default is enabled."
  value       = data.aws_ebs_default_kms_key.this.key_arn
}

output "id" {
  description = "Region of the default KMS Key."
  value       = data.aws_ebs_default_kms_key.this.id
}