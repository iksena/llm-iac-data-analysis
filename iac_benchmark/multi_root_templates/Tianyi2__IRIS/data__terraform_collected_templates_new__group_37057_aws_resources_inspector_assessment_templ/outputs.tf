output "arn" {
  description = "The template assessment ARN."
  value       = aws_inspector_assessment_template.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_inspector_assessment_template.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_inspector_assessment_template.this.region
}

output "name" {
  description = "The name of the assessment template."
  value       = aws_inspector_assessment_template.this.name
}

output "target_arn" {
  description = "The assessment target ARN to attach the template to."
  value       = aws_inspector_assessment_template.this.target_arn
}

output "duration" {
  description = "The duration of the inspector run."
  value       = aws_inspector_assessment_template.this.duration
}

output "rules_package_arns" {
  description = "The rules to be used during the run."
  value       = aws_inspector_assessment_template.this.rules_package_arns
}

output "event_subscription" {
  description = "Event subscription configuration."
  value       = var.event_subscription
}