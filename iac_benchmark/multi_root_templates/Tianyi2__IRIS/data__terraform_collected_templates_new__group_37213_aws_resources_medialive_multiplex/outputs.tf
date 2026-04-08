output "arn" {
  description = "ARN of the Multiplex"
  value       = aws_medialive_multiplex.this.arn
}

output "availability_zones" {
  description = "A list of availability zones"
  value       = aws_medialive_multiplex.this.availability_zones
}

output "id" {
  description = "ID of the Multiplex"
  value       = aws_medialive_multiplex.this.id
}

output "multiplex_settings" {
  description = "Multiplex settings"
  value       = aws_medialive_multiplex.this.multiplex_settings
}

output "name" {
  description = "Name of Multiplex"
  value       = aws_medialive_multiplex.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_medialive_multiplex.this.region
}

output "start_multiplex" {
  description = "Whether to start the Multiplex"
  value       = aws_medialive_multiplex.this.start_multiplex
}

output "tags" {
  description = "A map of tags assigned to the Multiplex"
  value       = aws_medialive_multiplex.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_medialive_multiplex.this.tags_all
}