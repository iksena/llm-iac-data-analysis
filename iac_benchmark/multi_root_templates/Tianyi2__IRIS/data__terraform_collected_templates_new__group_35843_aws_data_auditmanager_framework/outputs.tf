output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_auditmanager_framework.this.region
}

output "name" {
  description = "Name of the framework."
  value       = data.aws_auditmanager_framework.this.name
}

output "type" {
  description = "Type of framework."
  value       = data.aws_auditmanager_framework.this.framework_type
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the framework."
  value       = data.aws_auditmanager_framework.this.arn
}

output "id" {
  description = "Unique identifier for the framework."
  value       = data.aws_auditmanager_framework.this.id
}

output "compliance_type" {
  description = "Compliance type that the new custom framework supports."
  value       = data.aws_auditmanager_framework.this.compliance_type
}

output "control_sets" {
  description = "Control sets associated with the framework."
  value       = data.aws_auditmanager_framework.this.control_sets
}

output "description" {
  description = "Description of the framework."
  value       = data.aws_auditmanager_framework.this.description
}


output "tags" {
  description = "A map of tags assigned to the framework."
  value       = data.aws_auditmanager_framework.this.tags
}