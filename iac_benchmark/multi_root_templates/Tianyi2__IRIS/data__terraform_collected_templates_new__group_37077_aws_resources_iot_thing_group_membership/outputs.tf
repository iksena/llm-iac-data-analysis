output "id" {
  description = "The membership ID."
  value       = aws_iot_thing_group_membership.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_iot_thing_group_membership.this.region
}

output "thing_name" {
  description = "The name of the thing added to the group."
  value       = aws_iot_thing_group_membership.this.thing_name
}

output "thing_group_name" {
  description = "The name of the group to which the thing was added."
  value       = aws_iot_thing_group_membership.this.thing_group_name
}

output "override_dynamic_group" {
  description = "Whether dynamic thing groups are overridden with static thing groups."
  value       = aws_iot_thing_group_membership.this.override_dynamic_group
}