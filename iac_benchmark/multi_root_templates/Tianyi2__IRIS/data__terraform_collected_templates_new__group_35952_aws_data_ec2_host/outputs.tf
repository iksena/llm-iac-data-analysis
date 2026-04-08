output "id" {
  description = "ID of the Dedicated Host."
  value       = data.aws_ec2_host.this.id
}

output "arn" {
  description = "ARN of the Dedicated Host."
  value       = data.aws_ec2_host.this.arn
}

output "asset_id" {
  description = "The ID of the Outpost hardware asset on which the Dedicated Host is allocated."
  value       = data.aws_ec2_host.this.asset_id
}

output "auto_placement" {
  description = "Whether auto-placement is on or off."
  value       = data.aws_ec2_host.this.auto_placement
}

output "availability_zone" {
  description = "Availability Zone of the Dedicated Host."
  value       = data.aws_ec2_host.this.availability_zone
}

output "cores" {
  description = "Number of cores on the Dedicated Host."
  value       = data.aws_ec2_host.this.cores
}

output "host_recovery" {
  description = "Whether host recovery is enabled or disabled for the Dedicated Host."
  value       = data.aws_ec2_host.this.host_recovery
}

output "instance_family" {
  description = "Instance family supported by the Dedicated Host. For example, 'm5'."
  value       = data.aws_ec2_host.this.instance_family
}

output "instance_type" {
  description = "Instance type supported by the Dedicated Host. For example, 'm5.large'. If the host supports multiple instance types, no instanceType is returned."
  value       = data.aws_ec2_host.this.instance_type
}

output "outpost_arn" {
  description = "ARN of the AWS Outpost on which the Dedicated Host is allocated."
  value       = data.aws_ec2_host.this.outpost_arn
}

output "owner_id" {
  description = "ID of the AWS account that owns the Dedicated Host."
  value       = data.aws_ec2_host.this.owner_id
}

output "sockets" {
  description = "Number of sockets on the Dedicated Host."
  value       = data.aws_ec2_host.this.sockets
}

output "total_vcpus" {
  description = "Total number of vCPUs on the Dedicated Host."
  value       = data.aws_ec2_host.this.total_vcpus
}