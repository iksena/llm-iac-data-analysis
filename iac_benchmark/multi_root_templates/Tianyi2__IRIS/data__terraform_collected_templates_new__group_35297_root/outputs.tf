output "cluster_id" {
  value = aws_docdb_cluster.docdb.id
}

output "cluster_arn" {
  value = aws_docdb_cluster.docdb.arn
}

output "cluster_endpoint" {
  value = aws_docdb_cluster.docdb.endpoint
}

output "reader_endpoint" {
  value = aws_docdb_cluster.docdb.reader_endpoint
}

output "cluster_hosted_zone" {
  value = aws_docdb_cluster.docdb.hosted_zone_id
}

output "cluster_members" {
  value = aws_docdb_cluster.docdb.cluster_members
}

output "security_group_id" {
  description = "ID of the DocumentDB cluster Security Group"
  value       = try(aws_security_group.main[0].id, "")
}

output "security_group_arn" {
  description = "ARN of the DocumentDB cluster Security Group"
  value       = try(aws_security_group.main[0].arn, "")
}

output "security_group_name" {
  description = "Name of the DocumentDB cluster Security Group"
  value       = try(aws_security_group.main[0].name, "")
}
