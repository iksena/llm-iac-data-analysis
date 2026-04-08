output "arn" {
  description = "The ARN of the Thing Group."
  value       = aws_iot_thing_group.this.arn
}

output "id" {
  description = "The Thing Group ID."
  value       = aws_iot_thing_group.this.id
}

output "version" {
  description = "The current version of the Thing Group record in the registry."
  value       = aws_iot_thing_group.this.version
}