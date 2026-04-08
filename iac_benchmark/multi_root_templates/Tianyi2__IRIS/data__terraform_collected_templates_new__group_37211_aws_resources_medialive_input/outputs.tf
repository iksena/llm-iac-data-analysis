output "arn" {
  description = "ARN of the Input."
  value       = aws_medialive_input.this.arn
}

output "attached_channels" {
  description = "Channels attached to Input."
  value       = aws_medialive_input.this.attached_channels
}

output "input_class" {
  description = "The input class."
  value       = aws_medialive_input.this.input_class
}

output "input_partner_ids" {
  description = "A list of IDs for all Inputs which are partners of this one."
  value       = aws_medialive_input.this.input_partner_ids
}

output "input_source_type" {
  description = "Source type of the input."
  value       = aws_medialive_input.this.input_source_type
}

output "id" {
  description = "The ID of the MediaLive Input."
  value       = aws_medialive_input.this.id
}

output "name" {
  description = "Name of the input."
  value       = aws_medialive_input.this.name
}

output "input_security_groups" {
  description = "List of input security groups."
  value       = aws_medialive_input.this.input_security_groups
}

output "type" {
  description = "The different types of inputs that AWS Elemental MediaLive supports."
  value       = aws_medialive_input.this.type
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_medialive_input.this.tags_all
}