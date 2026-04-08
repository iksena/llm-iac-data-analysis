output "id" {
  description = "ID of the Elastic Beanstalk Environment"
  value       = aws_elastic_beanstalk_environment.this.id
}

output "name" {
  description = "Name of the Elastic Beanstalk Environment"
  value       = aws_elastic_beanstalk_environment.this.name
}

output "description" {
  description = "Description of the Elastic Beanstalk Environment"
  value       = aws_elastic_beanstalk_environment.this.description
}

output "tier" {
  description = "The environment tier specified"
  value       = aws_elastic_beanstalk_environment.this.tier
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_elastic_beanstalk_environment.this.tags_all
}

output "application" {
  description = "The Elastic Beanstalk Application specified for this environment"
  value       = aws_elastic_beanstalk_environment.this.application
}

output "setting" {
  description = "Settings specifically set for this Environment"
  value       = aws_elastic_beanstalk_environment.this.setting
}

output "all_settings" {
  description = "List of all option settings configured in this Environment. These are a combination of default settings and their overrides from setting in the configuration"
  value       = aws_elastic_beanstalk_environment.this.all_settings
}

output "cname" {
  description = "Fully qualified DNS name for this Environment"
  value       = aws_elastic_beanstalk_environment.this.cname
}

output "autoscaling_groups" {
  description = "The autoscaling groups used by this Environment"
  value       = aws_elastic_beanstalk_environment.this.autoscaling_groups
}

output "instances" {
  description = "Instances used by this Environment"
  value       = aws_elastic_beanstalk_environment.this.instances
}

output "launch_configurations" {
  description = "Launch configurations in use by this Environment"
  value       = aws_elastic_beanstalk_environment.this.launch_configurations
}

output "load_balancers" {
  description = "Elastic load balancers in use by this Environment"
  value       = aws_elastic_beanstalk_environment.this.load_balancers
}

output "queues" {
  description = "SQS queues in use by this Environment"
  value       = aws_elastic_beanstalk_environment.this.queues
}

output "triggers" {
  description = "Autoscaling triggers in use by this Environment"
  value       = aws_elastic_beanstalk_environment.this.triggers
}

output "endpoint_url" {
  description = "The URL to the Load Balancer for this Environment"
  value       = aws_elastic_beanstalk_environment.this.endpoint_url
}