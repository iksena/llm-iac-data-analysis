output "application" {
  description = "Name of the Beanstalk Application the version is associated with."
  value       = aws_elastic_beanstalk_application_version.this.application
}

output "bucket" {
  description = "S3 bucket that contains the Application Version source bundle."
  value       = aws_elastic_beanstalk_application_version.this.bucket
}

output "key" {
  description = "S3 object that is the Application Version source bundle."
  value       = aws_elastic_beanstalk_application_version.this.key
}

output "name" {
  description = "Unique name for the this Application Version."
  value       = aws_elastic_beanstalk_application_version.this.name
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_elastic_beanstalk_application_version.this.region
}

output "description" {
  description = "Short description of the Application Version."
  value       = aws_elastic_beanstalk_application_version.this.description
}

output "force_delete" {
  description = "On delete, force an Application Version to be deleted when it may be in use by multiple Elastic Beanstalk Environments."
  value       = aws_elastic_beanstalk_application_version.this.force_delete
}

output "process" {
  description = "Pre-processes and validates the environment manifest and configuration files in the source bundle."
  value       = aws_elastic_beanstalk_application_version.this.process
}

output "tags" {
  description = "Key-value map of tags for the Elastic Beanstalk Application Version."
  value       = aws_elastic_beanstalk_application_version.this.tags
}

output "arn" {
  description = "ARN assigned by AWS for this Elastic Beanstalk Application."
  value       = aws_elastic_beanstalk_application_version.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_elastic_beanstalk_application_version.this.tags_all
}