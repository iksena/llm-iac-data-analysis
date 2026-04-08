output "location_codes" {
  description = "Code for the locations."
  value       = data.aws_dx_locations.this.location_codes
}