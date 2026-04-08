output "bucket" {
  description = "The name of the Amazon S3 bucket where the spot instance data feed is located."
  value       = data.aws_spot_datafeed_subscription.this.bucket
}

output "prefix" {
  description = "The prefix for the data feed files."
  value       = data.aws_spot_datafeed_subscription.this.prefix
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_spot_datafeed_subscription.this.region
}