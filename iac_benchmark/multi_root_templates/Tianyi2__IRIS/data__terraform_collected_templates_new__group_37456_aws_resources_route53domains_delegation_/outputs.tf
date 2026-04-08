output "dnssec_key_id" {
  description = "An ID assigned to the created DS record."
  value       = aws_route53domains_delegation_signer_record.this.dnssec_key_id
}

output "domain_name" {
  description = "The name of the domain that has its parent DNS zone updated with the Delegation Signer record."
  value       = aws_route53domains_delegation_signer_record.this.domain_name
}

output "signing_attributes" {
  description = "The information about the key, including the algorithm, public key-value, and flags."
  value = {
    algorithm  = aws_route53domains_delegation_signer_record.this.signing_attributes[0].algorithm
    flags      = aws_route53domains_delegation_signer_record.this.signing_attributes[0].flags
    public_key = aws_route53domains_delegation_signer_record.this.signing_attributes[0].public_key
  }
}