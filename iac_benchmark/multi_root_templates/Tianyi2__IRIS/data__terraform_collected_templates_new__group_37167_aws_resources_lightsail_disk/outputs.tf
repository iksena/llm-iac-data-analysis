output "arn" {
  description = "ARN of the disk"
  value       = aws_lightsail_disk.this.arn
}

output "created_at" {
  description = "Date and time when the disk was created"
  value       = aws_lightsail_disk.this.created_at
}

output "id" {
  description = "Name of the disk (matches name)"
  value       = aws_lightsail_disk.this.id
}

output "support_code" {
  description = "Support code for the disk. Include this code in your email to support when you have questions about a disk in Lightsail"
  value       = aws_lightsail_disk.this.support_code
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lightsail_disk.this.tags_all
}