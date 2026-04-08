output "arn" {
  description = "Amazon Resource Name (ARN) of the control."
  value       = aws_auditmanager_control.this.arn
}

output "control_mapping_sources_source_id" {
  description = "Unique identifier for the source."
  value       = aws_auditmanager_control.this.control_mapping_sources[*].source_id
}

output "id" {
  description = "Unique identifier for the control."
  value       = aws_auditmanager_control.this.id
}

output "type" {
  description = "Type of control, such as a custom control or a standard control."
  value       = aws_auditmanager_control.this.type
}