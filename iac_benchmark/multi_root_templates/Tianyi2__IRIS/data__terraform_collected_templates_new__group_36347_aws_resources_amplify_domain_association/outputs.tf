output "arn" {
  description = "ARN for the domain association."
  value       = aws_amplify_domain_association.this.arn
}

output "certificate_verification_dns_record" {
  description = "DNS records for certificate verification in a space-delimited format."
  value       = aws_amplify_domain_association.this.certificate_verification_dns_record
}

output "sub_domain" {
  description = "The subdomain configurations with computed attributes."
  value = {
    for idx, sd in aws_amplify_domain_association.this.sub_domain : idx => {
      branch_name = sd.branch_name
      prefix      = sd.prefix
      dns_record  = sd.dns_record
      verified    = sd.verified
    }
  }
}

output "app_id" {
  description = "Unique ID for an Amplify app."
  value       = aws_amplify_domain_association.this.app_id
}

output "domain_name" {
  description = "Domain name for the domain association."
  value       = aws_amplify_domain_association.this.domain_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_amplify_domain_association.this.region
}

output "enable_auto_sub_domain" {
  description = "Whether automated creation of subdomains for branches is enabled."
  value       = aws_amplify_domain_association.this.enable_auto_sub_domain
}

output "wait_for_verification" {
  description = "Whether the resource waits for domain association status verification."
  value       = aws_amplify_domain_association.this.wait_for_verification
}

output "certificate_settings" {
  description = "The SSL/TLS certificate settings for the custom domain."
  value       = aws_amplify_domain_association.this.certificate_settings
}