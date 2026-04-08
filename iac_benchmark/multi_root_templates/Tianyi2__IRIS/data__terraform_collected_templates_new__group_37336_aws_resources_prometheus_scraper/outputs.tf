output "arn" {
  description = "The Amazon Resource Name (ARN) of the new scraper."
  value       = aws_prometheus_scraper.this.arn
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role that provides permissions for the scraper to discover, collect, and produce metrics."
  value       = aws_prometheus_scraper.this.role_arn
}

