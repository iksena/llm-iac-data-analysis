output "arn" {
  description = "The Amazon Resource Name (ARN) of the resource share."
  value       = aws_ram_resource_share.this.arn
}

output "id" {
  description = "The Amazon Resource Name (ARN) of the resource share."
  value       = aws_ram_resource_share.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ram_resource_share.this.tags_all
}