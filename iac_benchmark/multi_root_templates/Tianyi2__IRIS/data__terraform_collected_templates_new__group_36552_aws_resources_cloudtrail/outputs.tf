output "arn" {
  description = "ARN of the trail"
  value       = aws_cloudtrail.this.arn
}

output "home_region" {
  description = "Region in which the trail was created"
  value       = aws_cloudtrail.this.home_region
}

output "id" {
  description = "ARN of the trail"
  value       = aws_cloudtrail.this.id
}

output "sns_topic_arn" {
  description = "ARN of the Amazon SNS topic that CloudTrail uses to send notifications when log files are delivered"
  value       = aws_cloudtrail.this.sns_topic_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_cloudtrail.this.tags_all
}