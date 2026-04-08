output "arns" {
  description = "Set of Amazon Resource Names (ARNs)."
  value       = data.aws_outposts_outposts.this.arns
}

output "id" {
  description = "AWS Region."
  value       = data.aws_outposts_outposts.this.id
}

output "ids" {
  description = "Set of identifiers."
  value       = data.aws_outposts_outposts.this.ids
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_outposts_outposts.this.region
}

output "availability_zone" {
  description = "Availability Zone name."
  value       = data.aws_outposts_outposts.this.availability_zone
}

output "availability_zone_id" {
  description = "Availability Zone identifier."
  value       = data.aws_outposts_outposts.this.availability_zone_id
}

output "site_id" {
  description = "Site identifier."
  value       = data.aws_outposts_outposts.this.site_id
}

output "owner_id" {
  description = "AWS Account identifier of the Outpost owner."
  value       = data.aws_outposts_outposts.this.owner_id
}