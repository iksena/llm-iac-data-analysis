output "id" {
  description = "ID of the Key Pair."
  value       = data.aws_key_pair.this.id
}

output "arn" {
  description = "ARN of the Key Pair."
  value       = data.aws_key_pair.this.arn
}

output "create_time" {
  description = "Timestamp for when the key pair was created in ISO 8601 format."
  value       = data.aws_key_pair.this.create_time
}

output "fingerprint" {
  description = "SHA-1 digest of the DER encoded private key."
  value       = data.aws_key_pair.this.fingerprint
}

output "key_type" {
  description = "Type of key pair."
  value       = data.aws_key_pair.this.key_type
}

output "public_key" {
  description = "Public key material."
  value       = data.aws_key_pair.this.public_key
}

output "tags" {
  description = "Any tags assigned to the Key Pair."
  value       = data.aws_key_pair.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_key_pair.this.region
}

output "key_pair_id" {
  description = "Key Pair ID."
  value       = data.aws_key_pair.this.key_pair_id
}

output "key_name" {
  description = "Key Pair name."
  value       = data.aws_key_pair.this.key_name
}

output "include_public_key" {
  description = "Whether to include the public key material in the response."
  value       = data.aws_key_pair.this.include_public_key
}