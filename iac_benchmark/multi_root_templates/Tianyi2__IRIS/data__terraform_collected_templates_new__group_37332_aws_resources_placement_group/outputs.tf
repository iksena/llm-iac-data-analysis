output "arn" {
  description = "Amazon Resource Name (ARN) of the placement group."
  value       = aws_placement_group.this.arn
}

output "id" {
  description = "The name of the placement group."
  value       = aws_placement_group.this.id
}

output "placement_group_id" {
  description = "The ID of the placement group."
  value       = aws_placement_group.this.placement_group_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_placement_group.this.tags_all
}