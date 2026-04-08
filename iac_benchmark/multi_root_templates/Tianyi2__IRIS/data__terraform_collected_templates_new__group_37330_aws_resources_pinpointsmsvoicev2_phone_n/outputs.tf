output "arn" {
  description = "ARN of the phone number"
  value       = aws_pinpointsmsvoicev2_phone_number.this.arn
}

output "id" {
  description = "ID of the phone number"
  value       = aws_pinpointsmsvoicev2_phone_number.this.id
}

output "monthly_leasing_price" {
  description = "The monthly price, in US dollars, to lease the phone number"
  value       = aws_pinpointsmsvoicev2_phone_number.this.monthly_leasing_price
}

output "phone_number" {
  description = "The new phone number that was requested"
  value       = aws_pinpointsmsvoicev2_phone_number.this.phone_number
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_pinpointsmsvoicev2_phone_number.this.tags_all
}