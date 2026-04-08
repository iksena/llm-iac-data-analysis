output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_outposts_outpost.this.region
}

output "id" {
  description = "Identifier of the Outpost."
  value       = data.aws_outposts_outpost.this.id
}

output "name" {
  description = "Name of the Outpost."
  value       = data.aws_outposts_outpost.this.name
}

output "arn" {
  description = "ARN."
  value       = data.aws_outposts_outpost.this.arn
}

output "owner_id" {
  description = "AWS Account identifier of the Outpost owner."
  value       = data.aws_outposts_outpost.this.owner_id
}

output "availability_zone" {
  description = "Availability Zone name."
  value       = data.aws_outposts_outpost.this.availability_zone
}

output "availability_zone_id" {
  description = "Availability Zone identifier."
  value       = data.aws_outposts_outpost.this.availability_zone_id
}

output "description" {
  description = "The description of the Outpost."
  value       = data.aws_outposts_outpost.this.description
}

output "lifecycle_status" {
  description = "The life cycle status."
  value       = data.aws_outposts_outpost.this.lifecycle_status
}

output "site_arn" {
  description = "The Amazon Resource Name (ARN) of the site."
  value       = data.aws_outposts_outpost.this.site_arn
}

output "site_id" {
  description = "The ID of the site."
  value       = data.aws_outposts_outpost.this.site_id
}

output "supported_hardware_type" {
  description = "The hardware type."
  value       = data.aws_outposts_outpost.this.supported_hardware_type
}

output "tags" {
  description = "The Outpost tags."
  value       = data.aws_outposts_outpost.this.tags
}