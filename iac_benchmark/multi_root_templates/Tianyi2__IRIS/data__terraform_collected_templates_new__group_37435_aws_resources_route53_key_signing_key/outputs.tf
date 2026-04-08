output "digest_algorithm_mnemonic" {
  description = "A string used to represent the delegation signer digest algorithm. This value must follow the guidelines provided by RFC-8624 Section 3.3."
  value       = aws_route53_key_signing_key.this.digest_algorithm_mnemonic
}

output "digest_algorithm_type" {
  description = "An integer used to represent the delegation signer digest algorithm. This value must follow the guidelines provided by RFC-8624 Section 3.3."
  value       = aws_route53_key_signing_key.this.digest_algorithm_type
}

output "digest_value" {
  description = "A cryptographic digest of a DNSKEY resource record (RR). DNSKEY records are used to publish the public key that resolvers can use to verify DNSSEC signatures that are used to secure certain kinds of information provided by the DNS system."
  value       = aws_route53_key_signing_key.this.digest_value
}

output "dnskey_record" {
  description = "A string that represents a DNSKEY record."
  value       = aws_route53_key_signing_key.this.dnskey_record
}

output "ds_record" {
  description = "A string that represents a delegation signer (DS) record."
  value       = aws_route53_key_signing_key.this.ds_record
}

output "flag" {
  description = "An integer that specifies how the key is used. For key-signing key (KSK), this value is always 257."
  value       = aws_route53_key_signing_key.this.flag
}

output "id" {
  description = "Route 53 Hosted Zone identifier and KMS Key identifier, separated by a comma (,)."
  value       = aws_route53_key_signing_key.this.id
}

output "key_tag" {
  description = "An integer used to identify the DNSSEC record for the domain name. The process used to calculate the value is described in RFC-4034 Appendix B."
  value       = aws_route53_key_signing_key.this.key_tag
}

output "public_key" {
  description = "The public key, represented as a Base64 encoding, as required by RFC-4034 Page 5."
  value       = aws_route53_key_signing_key.this.public_key
}

output "signing_algorithm_mnemonic" {
  description = "A string used to represent the signing algorithm. This value must follow the guidelines provided by RFC-8624 Section 3.1."
  value       = aws_route53_key_signing_key.this.signing_algorithm_mnemonic
}

output "signing_algorithm_type" {
  description = "An integer used to represent the signing algorithm. This value must follow the guidelines provided by RFC-8624 Section 3.1."
  value       = aws_route53_key_signing_key.this.signing_algorithm_type
}

output "hosted_zone_id" {
  description = "Identifier of the Route 53 Hosted Zone."
  value       = aws_route53_key_signing_key.this.hosted_zone_id
}

output "key_management_service_arn" {
  description = "Amazon Resource Name (ARN) of the Key Management Service (KMS) Key."
  value       = aws_route53_key_signing_key.this.key_management_service_arn
}

output "name" {
  description = "Name of the key-signing key (KSK)."
  value       = aws_route53_key_signing_key.this.name
}

output "status" {
  description = "Status of the key-signing key (KSK)."
  value       = aws_route53_key_signing_key.this.status
}