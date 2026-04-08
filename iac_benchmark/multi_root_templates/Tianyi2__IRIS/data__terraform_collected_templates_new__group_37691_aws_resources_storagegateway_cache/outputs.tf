output "id" {
  description = "Combined gateway Amazon Resource Name (ARN) and local disk identifier."
  value       = aws_storagegateway_cache.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_storagegateway_cache.this.region
}

output "disk_id" {
  description = "Local disk identifier."
  value       = aws_storagegateway_cache.this.disk_id
}

output "gateway_arn" {
  description = "The Amazon Resource Name (ARN) of the gateway."
  value       = aws_storagegateway_cache.this.gateway_arn
}