output "name" {
  description = "Name of the configuration template"
  value       = aws_elastic_beanstalk_configuration_template.this.name
}

output "application" {
  description = "Name of the application associated with this configuration template"
  value       = aws_elastic_beanstalk_configuration_template.this.application
}

output "description" {
  description = "Description of the configuration template"
  value       = aws_elastic_beanstalk_configuration_template.this.description
}

output "environment_id" {
  description = "ID of the environment used with this configuration template"
  value       = aws_elastic_beanstalk_configuration_template.this.environment_id
}

output "setting" {
  description = "Settings configured for the template"
  value       = aws_elastic_beanstalk_configuration_template.this.setting
}

output "solution_stack_name" {
  description = "Solution stack name used for the template"
  value       = aws_elastic_beanstalk_configuration_template.this.solution_stack_name
}