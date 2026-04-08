output "id" {
  description = "Combined gateway Amazon Resource Name (ARN) and local disk identifier."
  value       = aws_storagegateway_upload_buffer.this.id
}