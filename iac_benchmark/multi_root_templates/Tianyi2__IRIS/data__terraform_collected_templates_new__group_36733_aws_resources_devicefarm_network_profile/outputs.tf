output "arn" {
  description = "The Amazon Resource Name of this network profile"
  value       = aws_devicefarm_network_profile.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_devicefarm_network_profile.this.tags_all
}