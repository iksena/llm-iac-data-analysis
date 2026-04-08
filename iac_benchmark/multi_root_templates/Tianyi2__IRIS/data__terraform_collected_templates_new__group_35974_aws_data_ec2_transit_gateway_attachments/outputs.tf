output "ids" {
  description = "A list of all attachments ids matching the filter. You can retrieve more information about the attachment using the aws_ec2_transit_gateway_attachment data source, searching by identifier."
  value       = data.aws_ec2_transit_gateway_attachments.this.ids
}

output "region" {
  description = "The region where this resource is managed."
  value       = data.aws_ec2_transit_gateway_attachments.this.region
}

output "filter" {
  description = "The filters applied to the data source."
  value       = var.filter
}