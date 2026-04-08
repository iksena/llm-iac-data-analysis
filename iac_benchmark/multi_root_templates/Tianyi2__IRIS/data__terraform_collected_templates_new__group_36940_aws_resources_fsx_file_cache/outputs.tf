output "arn" {
  description = "The Amazon Resource Name (ARN) for the resource."
  value       = aws_fsx_file_cache.this.arn
}

output "data_repository_association_ids" {
  description = "A list of IDs of data repository associations that are associated with this cache."
  value       = aws_fsx_file_cache.this.data_repository_association_ids
}

output "dns_name" {
  description = "The Domain Name System (DNS) name for the cache."
  value       = aws_fsx_file_cache.this.dns_name
}

output "file_cache_id" {
  description = "The system-generated, unique ID of the cache."
  value       = aws_fsx_file_cache.this.file_cache_id
}

output "id" {
  description = "The system-generated, unique ID of the cache."
  value       = aws_fsx_file_cache.this.id
}

output "network_interface_ids" {
  description = "A list of network interface IDs."
  value       = aws_fsx_file_cache.this.network_interface_ids
}

output "vpc_id" {
  description = "The ID of your virtual private cloud (VPC)."
  value       = aws_fsx_file_cache.this.vpc_id
}