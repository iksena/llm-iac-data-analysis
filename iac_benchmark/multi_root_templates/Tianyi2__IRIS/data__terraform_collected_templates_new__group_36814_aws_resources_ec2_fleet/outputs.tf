output "id" {
  description = "Fleet identifier"
  value       = aws_ec2_fleet.this.id
}

output "arn" {
  description = "The ARN of the fleet"
  value       = aws_ec2_fleet.this.arn
}

output "fleet_instance_set" {
  description = "Information about the instances that were launched by the fleet. Available only when type is set to instant."
  value       = aws_ec2_fleet.this.fleet_instance_set
}

output "fleet_state" {
  description = "The state of the EC2 Fleet"
  value       = aws_ec2_fleet.this.fleet_state
}

output "fulfilled_capacity" {
  description = "The number of units fulfilled by this request compared to the set target capacity"
  value       = aws_ec2_fleet.this.fulfilled_capacity
}

output "fulfilled_on_demand_capacity" {
  description = "The number of units fulfilled by this request compared to the set target On-Demand capacity"
  value       = aws_ec2_fleet.this.fulfilled_on_demand_capacity
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ec2_fleet.this.tags_all
}