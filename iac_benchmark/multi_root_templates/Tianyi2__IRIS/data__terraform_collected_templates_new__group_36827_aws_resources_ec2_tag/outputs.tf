output "id" {
  description = "EC2 resource identifier and key, separated by a comma (`,`)"
  value       = aws_ec2_tag.this.id
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_ec2_tag.this.region
}

output "resource_id" {
  description = "The ID of the EC2 resource"
  value       = aws_ec2_tag.this.resource_id
}

output "key" {
  description = "The tag name"
  value       = aws_ec2_tag.this.key
}

output "value" {
  description = "The value of the tag"
  value       = aws_ec2_tag.this.value
}