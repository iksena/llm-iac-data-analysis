output "abuse_contact_email" {
  description = "Email address to contact to report incorrect contact information for a domain, to report that the domain is being used to send spam, to report that someone is cybersquatting on a domain name, or report some other type of abuse"
  value       = aws_route53domains_domain.this.abuse_contact_email
}

output "abuse_contact_phone" {
  description = "Phone number for reporting abuse"
  value       = aws_route53domains_domain.this.abuse_contact_phone
}

output "admin_contact" {
  description = "Details about the domain administrative contact"
  value       = aws_route53domains_domain.this.admin_contact
}

output "admin_privacy" {
  description = "Whether domain administrative contact information is concealed from WHOIS queries"
  value       = aws_route53domains_domain.this.admin_privacy
}

output "auto_renew" {
  description = "Whether the domain registration is set to renew automatically"
  value       = aws_route53domains_domain.this.auto_renew
}

output "billing_contact" {
  description = "Details about the domain billing contact"
  value       = aws_route53domains_domain.this.billing_contact
}

output "billing_privacy" {
  description = "Whether domain billing contact information is concealed from WHOIS queries"
  value       = aws_route53domains_domain.this.billing_privacy
}

output "creation_date" {
  description = "The date when the domain was created as found in the response to a WHOIS query"
  value       = aws_route53domains_domain.this.creation_date
}

output "domain_name" {
  description = "The name of the domain"
  value       = aws_route53domains_domain.this.domain_name
}

output "duration_in_years" {
  description = "The number of years that you want to register the domain for"
  value       = aws_route53domains_domain.this.duration_in_years
}

output "expiration_date" {
  description = "The date when the registration for the domain is set to expire"
  value       = aws_route53domains_domain.this.expiration_date
}

output "hosted_zone_id" {
  description = "The ID of the public Route 53 hosted zone created for the domain. This hosted zone is deleted when the domain is deregistered"
  value       = aws_route53domains_domain.this.hosted_zone_id
}

output "name_server" {
  description = "The list of nameservers for the domain"
  value       = aws_route53domains_domain.this.name_server
}

output "registrant_contact" {
  description = "Details about the domain registrant"
  value       = aws_route53domains_domain.this.registrant_contact
}

output "registrant_privacy" {
  description = "Whether domain registrant contact information is concealed from WHOIS queries"
  value       = aws_route53domains_domain.this.registrant_privacy
}

output "registrar_name" {
  description = "Name of the registrar of the domain as identified in the registry"
  value       = aws_route53domains_domain.this.registrar_name
}

output "registrar_url" {
  description = "Web address of the registrar"
  value       = aws_route53domains_domain.this.registrar_url
}

output "status_list" {
  description = "List of domain name status codes"
  value       = aws_route53domains_domain.this.status_list
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_route53domains_domain.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_route53domains_domain.this.tags_all
}

output "tech_contact" {
  description = "Details about the domain technical contact"
  value       = aws_route53domains_domain.this.tech_contact
}

output "tech_privacy" {
  description = "Whether domain technical contact information is concealed from WHOIS queries"
  value       = aws_route53domains_domain.this.tech_privacy
}

output "transfer_lock" {
  description = "Whether the domain is locked for transfer"
  value       = aws_route53domains_domain.this.transfer_lock
}

output "updated_date" {
  description = "The last updated date of the domain as found in the response to a WHOIS query"
  value       = aws_route53domains_domain.this.updated_date
}

output "whois_server" {
  description = "The fully qualified name of the WHOIS server that can answer the WHOIS query for the domain"
  value       = aws_route53domains_domain.this.whois_server
}