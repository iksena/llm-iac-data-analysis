output "id" {
  description = "The key pair name."
  value       = aws_key_pair.this.id
}

output "arn" {
  description = "The key pair ARN."
  value       = aws_key_pair.this.arn
}

output "key_name" {
  description = "The key pair name."
  value       = aws_key_pair.this.key_name
}

output "key_pair_id" {
  description = "The key pair ID."
  value       = aws_key_pair.this.key_pair_id
}

output "key_type" {
  description = "The type of key pair."
  value       = aws_key_pair.this.key_type
}

output "fingerprint" {
  description = "The MD5 public key fingerprint as specified in section 4 of RFC 4716."
  value       = aws_key_pair.this.fingerprint
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_key_pair.this.tags_all
}