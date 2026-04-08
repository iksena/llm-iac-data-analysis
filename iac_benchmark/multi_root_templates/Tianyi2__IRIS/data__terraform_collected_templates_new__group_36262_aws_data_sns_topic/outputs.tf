output "arn" {
  description = "ARN of the found topic, suitable for referencing in other resources that support SNS topics"
  value       = data.aws_sns_topic.this.arn
}

output "id" {
  description = "ARN of the found topic, suitable for referencing in other resources that support SNS topics"
  value       = data.aws_sns_topic.this.id
}

output "tags" {
  description = "Map of tags for the resource"
  value       = data.aws_sns_topic.this.tags
}