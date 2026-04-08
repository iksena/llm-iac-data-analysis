output "arn" {
  description = "Amazon Resource Name (ARN) of the framework"
  value       = aws_auditmanager_framework.this.arn
}

output "control_sets" {
  description = "Control sets with their unique identifiers"
  value = [
    for cs in aws_auditmanager_framework.this.control_sets : {
      id   = cs.id
      name = cs.name
    }
  ]
}

output "id" {
  description = "Unique identifier for the framework"
  value       = aws_auditmanager_framework.this.id
}

output "framework_type" {
  description = "Framework type, such as a custom framework or a standard framework"
  value       = aws_auditmanager_framework.this.framework_type
}