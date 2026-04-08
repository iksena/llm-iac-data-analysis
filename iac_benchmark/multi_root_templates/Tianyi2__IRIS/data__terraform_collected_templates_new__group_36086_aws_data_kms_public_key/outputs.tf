output "arn" {
  description = "Key ARN of the asymmetric CMK from which the public key was downloaded"
  value       = data.aws_kms_public_key.this.arn
}

output "customer_master_key_spec" {
  description = "Type of the public key that was downloaded"
  value       = data.aws_kms_public_key.this.customer_master_key_spec
}

output "encryption_algorithms" {
  description = "Encryption algorithms that AWS KMS supports for this key. Only set when the key_usage of the public key is ENCRYPT_DECRYPT"
  value       = data.aws_kms_public_key.this.encryption_algorithms
}

output "id" {
  description = "Key ARN of the asymmetric CMK from which the public key was downloaded"
  value       = data.aws_kms_public_key.this.id
}

output "key_usage" {
  description = "Permitted use of the public key. Valid values are ENCRYPT_DECRYPT or SIGN_VERIFY"
  value       = data.aws_kms_public_key.this.key_usage
}

output "public_key" {
  description = "Exported public key. The value is a DER-encoded X.509 public key, also known as SubjectPublicKeyInfo (SPKI), as defined in RFC 5280. The value is Base64-encoded"
  value       = data.aws_kms_public_key.this.public_key
}

output "public_key_pem" {
  description = "Exported public key. The value is Privacy Enhanced Mail (PEM) encoded"
  value       = data.aws_kms_public_key.this.public_key_pem
}

output "signing_algorithms" {
  description = "Signing algorithms that AWS KMS supports for this key. Only set when the key_usage of the public key is SIGN_VERIFY"
  value       = data.aws_kms_public_key.this.signing_algorithms
}