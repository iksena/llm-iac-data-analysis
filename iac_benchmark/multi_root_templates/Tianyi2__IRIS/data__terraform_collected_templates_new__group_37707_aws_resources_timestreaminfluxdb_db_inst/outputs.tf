output "arn" {
  description = "ARN of the Timestream for InfluxDB Instance."
  value       = aws_timestreaminfluxdb_db_instance.this.arn
}

output "availability_zone" {
  description = "Availability Zone in which the DB instance resides."
  value       = aws_timestreaminfluxdb_db_instance.this.availability_zone
}

output "endpoint" {
  description = "Endpoint used to connect to InfluxDB. The default InfluxDB port is 8086."
  value       = aws_timestreaminfluxdb_db_instance.this.endpoint
}

output "id" {
  description = "ID of the Timestream for InfluxDB instance."
  value       = aws_timestreaminfluxdb_db_instance.this.id
}

output "influx_auth_parameters_secret_arn" {
  description = "ARN of the AWS Secrets Manager secret containing the initial InfluxDB authorization parameters."
  value       = aws_timestreaminfluxdb_db_instance.this.influx_auth_parameters_secret_arn
}

output "secondary_availability_zone" {
  description = "Availability Zone in which the standby instance is located when deploying with a MultiAZ standby instance."
  value       = aws_timestreaminfluxdb_db_instance.this.secondary_availability_zone
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_timestreaminfluxdb_db_instance.this.tags_all
}