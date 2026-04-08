output "id" {
  description = "Appsync Domain Name."
  value       = aws_appsync_domain_name.this.id
}

output "appsync_domain_name" {
  description = "Domain name that AppSync provides."
  value       = aws_appsync_domain_name.this.appsync_domain_name
}

output "hosted_zone_id" {
  description = "ID of your Amazon Route 53 hosted zone."
  value       = aws_appsync_domain_name.this.hosted_zone_id
}