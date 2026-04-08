output "group_names" {
  description = "A set of the Availability Zone Group names. For Availability Zones, this is the same value as the Region name. For Local Zones, the name of the associated group."
  value       = data.aws_availability_zones.this.group_names
}

output "id" {
  description = "Region of the Availability Zones."
  value       = data.aws_availability_zones.this.id
}

output "names" {
  description = "List of the Availability Zone names available to the account."
  value       = data.aws_availability_zones.this.names
}

output "zone_ids" {
  description = "List of the Availability Zone IDs available to the account."
  value       = data.aws_availability_zones.this.zone_ids
}