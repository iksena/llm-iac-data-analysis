output "id" {
  description = "The EMR Instance ID"
  value       = aws_emr_instance_group.this.id
}

output "running_instance_count" {
  description = "The number of instances currently running in this instance group"
  value       = aws_emr_instance_group.this.running_instance_count
}

output "status" {
  description = "The current status of the instance group"
  value       = aws_emr_instance_group.this.status
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_emr_instance_group.this.region
}

output "name" {
  description = "Human friendly name given to the instance group"
  value       = aws_emr_instance_group.this.name
}

output "cluster_id" {
  description = "ID of the EMR Cluster to attach to"
  value       = aws_emr_instance_group.this.cluster_id
}

output "instance_type" {
  description = "The EC2 instance type for all instances in the instance group"
  value       = aws_emr_instance_group.this.instance_type
}

output "instance_count" {
  description = "Target number of instances for the instance group"
  value       = aws_emr_instance_group.this.instance_count
}

output "bid_price" {
  description = "The bid price for each EC2 instance in the instance group"
  value       = aws_emr_instance_group.this.bid_price
}

output "ebs_optimized" {
  description = "Indicates whether an Amazon EBS volume is EBS-optimized"
  value       = aws_emr_instance_group.this.ebs_optimized
}

output "autoscaling_policy" {
  description = "The autoscaling policy document"
  value       = aws_emr_instance_group.this.autoscaling_policy
}

output "configurations_json" {
  description = "A JSON string for supplying list of configurations specific to the EMR instance group"
  value       = aws_emr_instance_group.this.configurations_json
}

output "ebs_config" {
  description = "EBS configuration blocks"
  value       = aws_emr_instance_group.this.ebs_config
}