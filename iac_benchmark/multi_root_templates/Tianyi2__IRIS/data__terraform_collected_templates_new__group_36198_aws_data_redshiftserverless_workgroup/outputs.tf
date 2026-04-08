output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Serverless Workgroup"
  value       = data.aws_redshiftserverless_workgroup.this.arn
}

output "id" {
  description = "The Redshift Workgroup Name"
  value       = data.aws_redshiftserverless_workgroup.this.id
}

output "endpoint" {
  description = "The endpoint that is created from the workgroup"
  value       = data.aws_redshiftserverless_workgroup.this.endpoint
}

output "enhanced_vpc_routing" {
  description = "The value that specifies whether to turn on enhanced virtual private cloud (VPC) routing, which forces Amazon Redshift Serverless to route traffic through your VPC instead of over the internet"
  value       = data.aws_redshiftserverless_workgroup.this.enhanced_vpc_routing
}

output "publicly_accessible" {
  description = "A value that specifies whether the workgroup can be accessed from a public network"
  value       = data.aws_redshiftserverless_workgroup.this.publicly_accessible
}

output "security_group_ids" {
  description = "An array of security group IDs to associate with the workgroup"
  value       = data.aws_redshiftserverless_workgroup.this.security_group_ids
}

output "subnet_ids" {
  description = "An array of VPC subnet IDs to associate with the workgroup"
  value       = data.aws_redshiftserverless_workgroup.this.subnet_ids
}

output "track_name" {
  description = "The name of the track for the workgroup"
  value       = data.aws_redshiftserverless_workgroup.this.track_name
}

output "workgroup_id" {
  description = "The Redshift Workgroup ID"
  value       = data.aws_redshiftserverless_workgroup.this.workgroup_id
}

output "endpoint_address" {
  description = "The DNS address of the VPC endpoint"
  value       = try(data.aws_redshiftserverless_workgroup.this.endpoint[0].address, null)
}

output "endpoint_port" {
  description = "The port that Amazon Redshift Serverless listens on"
  value       = try(data.aws_redshiftserverless_workgroup.this.endpoint[0].port, null)
}

output "vpc_endpoint" {
  description = "The VPC endpoint or the Redshift Serverless workgroup"
  value       = try(data.aws_redshiftserverless_workgroup.this.endpoint[0].vpc_endpoint, null)
}

output "vpc_endpoint_id" {
  description = "The DNS address of the VPC endpoint"
  value       = try(data.aws_redshiftserverless_workgroup.this.endpoint[0].vpc_endpoint[0].vpc_endpoint_id, null)
}

output "vpc_id" {
  description = "The port that Amazon Redshift Serverless listens on"
  value       = try(data.aws_redshiftserverless_workgroup.this.endpoint[0].vpc_endpoint[0].vpc_id, null)
}

output "network_interfaces" {
  description = "The network interfaces of the endpoint"
  value       = try(data.aws_redshiftserverless_workgroup.this.endpoint[0].vpc_endpoint[0].network_interface, null)
}