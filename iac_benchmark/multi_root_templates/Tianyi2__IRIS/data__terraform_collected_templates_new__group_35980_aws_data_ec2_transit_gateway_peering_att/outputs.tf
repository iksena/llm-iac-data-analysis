output "ids" {
  description = "A list of all attachments ids matching the filter."
  value       = data.aws_ec2_transit_gateway_peering_attachments.this.ids
}

output "region" {
  description = "The AWS region where the resource is located."
  value       = data.aws_ec2_transit_gateway_peering_attachments.this.region
}

output "filter" {
  description = "The filters applied to the data source."
  value       = var.filter
}