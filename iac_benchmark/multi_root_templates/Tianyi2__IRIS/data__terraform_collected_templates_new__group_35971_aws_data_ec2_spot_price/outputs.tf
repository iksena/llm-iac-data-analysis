output "id" {
  description = "AWS Region."
  value       = data.aws_ec2_spot_price.this.id
}

output "spot_price" {
  description = "Most recent Spot Price value for the given instance type and AZ."
  value       = data.aws_ec2_spot_price.this.spot_price
}

output "spot_price_timestamp" {
  description = "The timestamp at which the Spot Price value was published."
  value       = data.aws_ec2_spot_price.this.spot_price_timestamp
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ec2_spot_price.this.region
}

output "instance_type" {
  description = "Type of instance for which Spot Price information was queried."
  value       = data.aws_ec2_spot_price.this.instance_type
}

output "availability_zone" {
  description = "Availability zone in which Spot price information was queried."
  value       = data.aws_ec2_spot_price.this.availability_zone
}

output "filter" {
  description = "Configuration blocks containing name-values filters that were applied."
  value       = data.aws_ec2_spot_price.this.filter
}