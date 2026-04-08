output "id" {
  description = "Combination of attributes to create a unique id: disk_name,instance_name"
  value       = aws_lightsail_disk_attachment.this.id
}