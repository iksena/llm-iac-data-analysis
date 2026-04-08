output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_availability_zone.this.region
}

output "all_availability_zones" {
  description = "Whether to include all Availability Zones and Local Zones regardless of opt in status."
  value       = data.aws_availability_zone.this.all_availability_zones
}

output "filter" {
  description = "Configuration block(s) for filtering."
  value       = data.aws_availability_zone.this.filter
}

output "name" {
  description = "Full name of the availability zone."
  value       = data.aws_availability_zone.this.name
}

output "state" {
  description = "Specific availability zone state."
  value       = data.aws_availability_zone.this.state
}

output "zone_id" {
  description = "Zone ID of the availability zone."
  value       = data.aws_availability_zone.this.zone_id
}

output "group_long_name" {
  description = "The long name of the Availability Zone group, Local Zone group, or Wavelength Zone group."
  value       = data.aws_availability_zone.this.group_long_name
}

output "group_name" {
  description = "The name of the zone group. For example: us-east-1-zg-1, us-west-2-lax-1, or us-east-1-wl1-bos-wlz-1."
  value       = data.aws_availability_zone.this.group_name
}

output "name_suffix" {
  description = "Part of the AZ name that appears after the region name, uniquely identifying the AZ within its region."
  value       = data.aws_availability_zone.this.name_suffix
}

output "network_border_group" {
  description = "The name of the location from which the address is advertised."
  value       = data.aws_availability_zone.this.network_border_group
}

output "opt_in_status" {
  description = "For Availability Zones, this always has the value of opt-in-not-required. For Local Zones, this is the opt in status."
  value       = data.aws_availability_zone.this.opt_in_status
}

output "parent_zone_id" {
  description = "ID of the zone that handles some of the Local Zone or Wavelength Zone control plane operations, such as API calls."
  value       = data.aws_availability_zone.this.parent_zone_id
}

output "parent_zone_name" {
  description = "Name of the zone that handles some of the Local Zone or Wavelength Zone control plane operations, such as API calls."
  value       = data.aws_availability_zone.this.parent_zone_name
}

output "zone_type" {
  description = "Type of zone. Values are availability-zone, local-zone, and wavelength-zone."
  value       = data.aws_availability_zone.this.zone_type
}