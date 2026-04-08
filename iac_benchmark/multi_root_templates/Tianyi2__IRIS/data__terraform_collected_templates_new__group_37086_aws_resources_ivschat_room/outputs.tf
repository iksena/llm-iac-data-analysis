output "arn" {
  description = "ARN of the Room."
  value       = aws_ivschat_room.this.arn
}

output "id" {
  description = "Room ID"
  value       = aws_ivschat_room.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ivschat_room.this.tags_all
}