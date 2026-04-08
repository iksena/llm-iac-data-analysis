output "endpoint" {
  description = "Hostname for the target RDS DB Instance. Only returned for RDS_INSTANCE type."
  value       = aws_db_proxy_target.this.endpoint
}

output "id" {
  description = "Identifier of db_proxy_name, target_group_name, target type (e.g., RDS_INSTANCE or TRACKED_CLUSTER), and resource identifier separated by forward slashes (/)."
  value       = aws_db_proxy_target.this.id
}

output "port" {
  description = "Port for the target RDS DB Instance or Aurora DB Cluster."
  value       = aws_db_proxy_target.this.port
}

output "rds_resource_id" {
  description = "Identifier representing the DB Instance or DB Cluster target."
  value       = aws_db_proxy_target.this.rds_resource_id
}

output "target_arn" {
  description = "Amazon Resource Name (ARN) for the DB instance or DB cluster. Currently not returned by the RDS API."
  value       = aws_db_proxy_target.this.target_arn
}

output "tracked_cluster_id" {
  description = "DB Cluster identifier for the DB Instance target. Not returned unless manually importing an RDS_INSTANCE target that is part of a DB Cluster."
  value       = aws_db_proxy_target.this.tracked_cluster_id
}

output "type" {
  description = "Type of target. E.g., RDS_INSTANCE or TRACKED_CLUSTER"
  value       = aws_db_proxy_target.this.type
}