output "arn" {
  description = "The ARN assigned by AWS for this Elastic Beanstalk Application"
  value       = aws_elastic_beanstalk_application.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_elastic_beanstalk_application.this.tags_all
}

output "name" {
  description = "The name of the application"
  value       = aws_elastic_beanstalk_application.this.name
}

output "description" {
  description = "Short description of the application"
  value       = aws_elastic_beanstalk_application.this.description
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_elastic_beanstalk_application.this.region
}