output "key_arn" {
  description = "The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) used to encrypt the EBS volume."
  value       = aws_ebs_default_kms_key.this.key_arn
}

output "region" {
  description = "The region where this resource is managed."
  value       = aws_ebs_default_kms_key.this.region
}