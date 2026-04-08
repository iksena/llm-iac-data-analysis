output "arn" {
  description = "The Amazon Resource Name of this instance profile"
  value       = aws_devicefarm_instance_profile.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_devicefarm_instance_profile.this.tags_all
}