output "associated_portal_arns" {
  description = "List of ARNs of the web portals associated with the trust store."
  value       = aws_workspacesweb_trust_store.this.associated_portal_arns
}

output "trust_store_arn" {
  description = "ARN of the trust store."
  value       = aws_workspacesweb_trust_store.this.trust_store_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_workspacesweb_trust_store.this.tags_all
}

output "certificate_details" {
  description = "Details of the certificates in the trust store."
  value = [
    for cert in aws_workspacesweb_trust_store.this.certificate : {
      issuer           = cert.issuer
      not_valid_after  = cert.not_valid_after
      not_valid_before = cert.not_valid_before
      subject          = cert.subject
      thumbprint       = cert.thumbprint
    }
  ]
}