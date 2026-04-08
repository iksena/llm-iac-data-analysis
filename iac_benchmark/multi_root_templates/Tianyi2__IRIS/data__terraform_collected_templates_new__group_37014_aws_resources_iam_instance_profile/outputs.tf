output "arn" {
  description = "ARN assigned by AWS to the instance profile."
  value       = aws_iam_instance_profile.this.arn
}

output "create_date" {
  description = "Creation timestamp of the instance profile."
  value       = aws_iam_instance_profile.this.create_date
}

output "id" {
  description = "Instance profile's ID."
  value       = aws_iam_instance_profile.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iam_instance_profile.this.tags_all
}

output "unique_id" {
  description = "Unique ID assigned by AWS."
  value       = aws_iam_instance_profile.this.unique_id
}