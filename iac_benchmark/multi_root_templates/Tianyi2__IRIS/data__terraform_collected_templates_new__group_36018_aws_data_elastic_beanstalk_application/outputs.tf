output "id" {
  description = "Name of the application"
  value       = data.aws_elastic_beanstalk_application.this.id
}

output "arn" {
  description = "ARN of the application"
  value       = data.aws_elastic_beanstalk_application.this.arn
}

output "description" {
  description = "Short description of the application"
  value       = data.aws_elastic_beanstalk_application.this.description
}

output "appversion_lifecycle" {
  description = "Application version lifecycle configuration"
  value       = data.aws_elastic_beanstalk_application.this.appversion_lifecycle
}

output "name" {
  description = "Name of the application"
  value       = data.aws_elastic_beanstalk_application.this.name
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_elastic_beanstalk_application.this.region
}