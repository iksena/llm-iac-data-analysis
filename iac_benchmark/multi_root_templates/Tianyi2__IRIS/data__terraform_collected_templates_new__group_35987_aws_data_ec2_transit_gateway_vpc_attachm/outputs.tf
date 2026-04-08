output "ids" {
  description = "A list of all attachments ids matching the filter."
  value       = data.aws_ec2_transit_gateway_vpc_attachments.this.ids
}