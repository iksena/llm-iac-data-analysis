output "arn" {
  description = "ARN of the cell"
  value       = aws_route53recoveryreadiness_cell.this.arn
}

output "parent_readiness_scopes" {
  description = "List of readiness scopes (recovery groups or cells) that contain this cell."
  value       = aws_route53recoveryreadiness_cell.this.parent_readiness_scopes
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53recoveryreadiness_cell.this.tags_all
}

output "cell_name" {
  description = "Unique name describing the cell."
  value       = aws_route53recoveryreadiness_cell.this.cell_name
}

output "cells" {
  description = "List of cell arns to add as nested fault domains within this cell."
  value       = aws_route53recoveryreadiness_cell.this.cells
}

output "tags" {
  description = "Key-value mapping of resource tags."
  value       = aws_route53recoveryreadiness_cell.this.tags
}