output "id" {
  description = "EC2 Instance Type."
  value       = data.aws_ec2_instance_type_offering.this.id
}

output "instance_type" {
  description = "EC2 Instance Type."
  value       = data.aws_ec2_instance_type_offering.this.instance_type
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_instance_type_offering.this.region
}

output "location_type" {
  description = "Location type used for the query."
  value       = data.aws_ec2_instance_type_offering.this.location_type
}

output "preferred_instance_types" {
  description = "Ordered list of preferred EC2 Instance Types that was used."
  value       = data.aws_ec2_instance_type_offering.this.preferred_instance_types
}

output "filter" {
  description = "Filters that were applied to the query."
  value       = var.filter
}