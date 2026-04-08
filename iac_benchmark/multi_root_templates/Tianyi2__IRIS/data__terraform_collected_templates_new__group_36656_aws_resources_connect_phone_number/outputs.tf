output "arn" {
  description = "The ARN of the phone number."
  value       = aws_connect_phone_number.this.arn
}

output "phone_number" {
  description = "The phone number. Phone numbers are formatted [+] [country code] [subscriber number including area code]."
  value       = aws_connect_phone_number.this.phone_number
}

output "id" {
  description = "The identifier of the phone number."
  value       = aws_connect_phone_number.this.id
}

output "status" {
  description = "A block that specifies status of the phone number."
  value       = aws_connect_phone_number.this.status
}

output "status_message" {
  description = "The status message."
  value       = try(aws_connect_phone_number.this.status[0].message, null)
}

output "status_status" {
  description = "The status of the phone number. Valid Values: CLAIMED | IN_PROGRESS | FAILED."
  value       = try(aws_connect_phone_number.this.status[0].status, null)
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_phone_number.this.tags_all
}