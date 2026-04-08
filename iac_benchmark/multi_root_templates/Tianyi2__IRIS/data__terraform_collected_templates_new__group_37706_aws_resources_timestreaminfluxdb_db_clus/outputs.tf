output "arn" {
  description = "ARN of the Timestream for InfluxDB cluster"
  value       = aws_timestreaminfluxdb_db_cluster.this.arn
}

output "endpoint" {
  description = "Endpoint used to connect to InfluxDB. The default InfluxDB port is 8086"
  value       = aws_timestreaminfluxdb_db_cluster.this.endpoint
}

output "id" {
  description = "ID of the Timestream for InfluxDB cluster"
  value       = aws_timestreaminfluxdb_db_cluster.this.id
}

output "influx_auth_parameters_secret_arn" {
  description = "ARN of the AWS Secrets Manager secret containing the initial InfluxDB authorization parameters"
  value       = aws_timestreaminfluxdb_db_cluster.this.influx_auth_parameters_secret_arn
  sensitive   = true
}

output "reader_endpoint" {
  description = "The endpoint used to connect to the Timestream for InfluxDB cluster for read-only operations"
  value       = aws_timestreaminfluxdb_db_cluster.this.reader_endpoint
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_timestreaminfluxdb_db_cluster.this.tags_all
}