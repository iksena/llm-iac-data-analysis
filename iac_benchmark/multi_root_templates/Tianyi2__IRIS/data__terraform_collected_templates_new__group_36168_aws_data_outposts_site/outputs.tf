output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_outposts_site.this.region
}

output "id" {
  description = "Identifier of the Site."
  value       = data.aws_outposts_site.this.id
}

output "name" {
  description = "Name of the Site."
  value       = data.aws_outposts_site.this.name
}

output "account_id" {
  description = "AWS Account identifier."
  value       = data.aws_outposts_site.this.account_id
}

output "description" {
  description = "Description."
  value       = data.aws_outposts_site.this.description
}