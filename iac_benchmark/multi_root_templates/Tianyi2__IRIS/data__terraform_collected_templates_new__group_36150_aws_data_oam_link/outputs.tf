output "arn" {
  description = "ARN of the link."
  value       = data.aws_oam_link.this.arn
}

output "id" {
  description = "ARN of the link. Use `arn` instead."
  value       = data.aws_oam_link.this.id
}

output "label" {
  description = "Label that is assigned to this link."
  value       = data.aws_oam_link.this.label
}

output "label_template" {
  description = "Human-readable name used to identify this source account when you are viewing data from it in the monitoring account."
  value       = data.aws_oam_link.this.label_template
}

output "link_configuration" {
  description = "Configuration for creating filters that specify that only some metric namespaces or log groups are to be shared from the source account to the monitoring account."
  value       = data.aws_oam_link.this.link_configuration
}

output "link_id" {
  description = "ID string that AWS generated as part of the link ARN."
  value       = data.aws_oam_link.this.link_id
}

output "resource_types" {
  description = "Types of data that the source account shares with the monitoring account."
  value       = data.aws_oam_link.this.resource_types
}

output "sink_arn" {
  description = "ARN of the sink that is used for this link."
  value       = data.aws_oam_link.this.sink_arn
}