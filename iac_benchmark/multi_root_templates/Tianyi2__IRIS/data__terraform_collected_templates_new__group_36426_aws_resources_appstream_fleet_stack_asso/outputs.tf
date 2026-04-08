output "id" {
  description = "Unique ID of the appstream stack fleet association, composed of the fleet_name and stack_name separated by a slash (/)."
  value       = aws_appstream_fleet_stack_association.this.id
}