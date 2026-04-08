output "group_name" {
  description = "Name of the Group."
  value       = aws_synthetics_group_association.this.group_name
}

output "group_id" {
  description = "ID of the Group."
  value       = aws_synthetics_group_association.this.group_id
}