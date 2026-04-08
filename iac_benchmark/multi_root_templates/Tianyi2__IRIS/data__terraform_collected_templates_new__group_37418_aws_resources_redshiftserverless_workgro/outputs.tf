output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Serverless Workgroup."
  value       = aws_redshiftserverless_workgroup.this.arn
}

output "id" {
  description = "The Redshift Workgroup Name."
  value       = aws_redshiftserverless_workgroup.this.id
}

output "workgroup_id" {
  description = "The Redshift Workgroup ID."
  value       = aws_redshiftserverless_workgroup.this.workgroup_id
}

output "endpoint" {
  description = "The endpoint that is created from the workgroup."
  value       = aws_redshiftserverless_workgroup.this.endpoint
}

output "endpoint_address" {
  description = "The DNS address of the VPC endpoint."
  value       = try(aws_redshiftserverless_workgroup.this.endpoint[0].address, null)
}

output "endpoint_port" {
  description = "The port that Amazon Redshift Serverless listens on."
  value       = try(aws_redshiftserverless_workgroup.this.endpoint[0].port, null)
}

output "endpoint_vpc_endpoint" {
  description = "The VPC endpoint or the Redshift Serverless workgroup."
  value       = try(aws_redshiftserverless_workgroup.this.endpoint[0].vpc_endpoint, null)
}

output "endpoint_vpc_endpoint_id" {
  description = "The DNS address of the VPC endpoint."
  value       = try(aws_redshiftserverless_workgroup.this.endpoint[0].vpc_endpoint[0].vpc_endpoint_id, null)
}

output "endpoint_vpc_id" {
  description = "The port that Amazon Redshift Serverless listens on."
  value       = try(aws_redshiftserverless_workgroup.this.endpoint[0].vpc_endpoint[0].vpc_id, null)
}

output "endpoint_network_interface" {
  description = "The network interfaces of the endpoint."
  value       = try(aws_redshiftserverless_workgroup.this.endpoint[0].vpc_endpoint[0].network_interface, null)
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshiftserverless_workgroup.this.tags_all
}