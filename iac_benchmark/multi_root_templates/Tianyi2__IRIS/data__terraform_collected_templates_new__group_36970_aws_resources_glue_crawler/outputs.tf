output "id" {
  description = "Crawler name"
  value       = aws_glue_crawler.this.id
}

output "arn" {
  description = "The ARN of the crawler"
  value       = aws_glue_crawler.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_glue_crawler.this.tags_all
}