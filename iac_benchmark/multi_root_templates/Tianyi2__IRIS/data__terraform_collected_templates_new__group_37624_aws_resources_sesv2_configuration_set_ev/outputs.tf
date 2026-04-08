output "id" {
  description = "A pipe-delimited string combining configuration_set_name and event_destination_name."
  value       = aws_sesv2_configuration_set_event_destination.this.id
}