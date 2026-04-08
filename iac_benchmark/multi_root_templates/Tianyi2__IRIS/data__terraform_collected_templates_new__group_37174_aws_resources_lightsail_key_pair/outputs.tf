output "arn" {
  description = "ARN of the Lightsail key pair."
  value       = aws_lightsail_key_pair.this.arn
}

output "encrypted_fingerprint" {
  description = "MD5 public key fingerprint for the encrypted private key."
  value       = aws_lightsail_key_pair.this.encrypted_fingerprint
}

output "encrypted_private_key" {
  description = "Private key material, base 64 encoded and encrypted with the given pgp_key. This is only populated when creating a new key and pgp_key is supplied."
  value       = aws_lightsail_key_pair.this.encrypted_private_key
  sensitive   = true
}

output "fingerprint" {
  description = "MD5 public key fingerprint as specified in section 4 of RFC 4716."
  value       = aws_lightsail_key_pair.this.fingerprint
}

output "id" {
  description = "Name used for this key pair."
  value       = aws_lightsail_key_pair.this.id
}

output "private_key" {
  description = "Private key, base64 encoded. This is only populated when creating a new key, and when no pgp_key is provided."
  value       = aws_lightsail_key_pair.this.private_key
  sensitive   = true
}

output "public_key" {
  description = "Public key, base64 encoded."
  value       = aws_lightsail_key_pair.this.public_key
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_lightsail_key_pair.this.tags_all
}