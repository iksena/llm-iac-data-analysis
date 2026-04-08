output "arn" {
  description = "The Amazon Resource Name of this Device Pool"
  value       = aws_devicefarm_device_pool.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_devicefarm_device_pool.this.tags_all
}