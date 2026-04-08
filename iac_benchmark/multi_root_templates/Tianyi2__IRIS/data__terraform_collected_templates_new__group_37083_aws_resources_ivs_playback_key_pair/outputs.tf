output "arn" {
  description = "ARN of the Playback Key Pair."
  value       = aws_ivs_playback_key_pair.this.arn
}

output "fingerprint" {
  description = "Key-pair identifier."
  value       = aws_ivs_playback_key_pair.this.fingerprint
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ivs_playback_key_pair.this.tags_all
}