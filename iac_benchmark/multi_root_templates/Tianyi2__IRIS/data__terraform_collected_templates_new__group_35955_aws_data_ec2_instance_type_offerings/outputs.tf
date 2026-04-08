output "id" {
  description = "AWS Region"
  value       = data.aws_ec2_instance_type_offerings.this.id
}

output "instance_types" {
  description = "List of EC2 Instance Types"
  value       = data.aws_ec2_instance_type_offerings.this.instance_types
}

output "locations" {
  description = "List of locations"
  value       = data.aws_ec2_instance_type_offerings.this.locations
}

output "location_types" {
  description = "List of location types"
  value       = data.aws_ec2_instance_type_offerings.this.location_types
}