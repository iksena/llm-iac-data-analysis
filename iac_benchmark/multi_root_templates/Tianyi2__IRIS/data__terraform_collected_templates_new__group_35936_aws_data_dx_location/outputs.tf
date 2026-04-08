output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_dx_location.this.region
}

output "location_code" {
  description = "Code for the location"
  value       = data.aws_dx_location.this.location_code
}

output "available_macsec_port_speeds" {
  description = "The available MAC Security (MACsec) port speeds for the location"
  value       = data.aws_dx_location.this.available_macsec_port_speeds
}

output "available_port_speeds" {
  description = "The available port speeds for the location"
  value       = data.aws_dx_location.this.available_port_speeds
}

output "available_providers" {
  description = "Names of the service providers for the location"
  value       = data.aws_dx_location.this.available_providers
}

output "location_name" {
  description = "Name of the location. This includes the name of the colocation partner and the physical site of the building"
  value       = data.aws_dx_location.this.location_name
}