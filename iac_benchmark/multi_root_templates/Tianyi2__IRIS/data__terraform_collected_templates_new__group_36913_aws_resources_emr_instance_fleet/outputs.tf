output "id" {
  description = "The unique identifier of the instance fleet."
  value       = aws_emr_instance_fleet.this.id
}

output "provisioned_on_demand_capacity" {
  description = "The number of On-Demand units that have been provisioned for the instance fleet to fulfill TargetOnDemandCapacity. This provisioned capacity might be less than or greater than TargetOnDemandCapacity."
  value       = aws_emr_instance_fleet.this.provisioned_on_demand_capacity
}

output "provisioned_spot_capacity" {
  description = "The number of Spot units that have been provisioned for this instance fleet to fulfill TargetSpotCapacity. This provisioned capacity might be less than or greater than TargetSpotCapacity."
  value       = aws_emr_instance_fleet.this.provisioned_spot_capacity
}

