output "arn" {
  description = "ARN of the Internet Gateway."
  value       = data.aws_internet_gateway.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_internet_gateway.this.region
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = data.aws_internet_gateway.this.internet_gateway_id
}

output "tags" {
  description = "Map of tags assigned to the Internet Gateway."
  value       = data.aws_internet_gateway.this.tags
}

output "owner_id" {
  description = "ID of the AWS account that owns the internet gateway."
  value       = data.aws_internet_gateway.this.owner_id
}

output "attachments" {
  description = "List of VPC attachments."
  value = [
    for attachment in data.aws_internet_gateway.this.attachments : {
      owner_id = attachment.owner_id
      state    = attachment.state
      vpc_id   = attachment.vpc_id
    }
  ]
}