output "arn" {
  description = "ARN of the database."
  value       = aws_lightsail_database.this.arn
}

output "ca_certificate_identifier" {
  description = "Certificate associated with the database."
  value       = aws_lightsail_database.this.ca_certificate_identifier
}

output "cpu_count" {
  description = "Number of vCPUs for the database."
  value       = aws_lightsail_database.this.cpu_count
}

output "created_at" {
  description = "Date and time when the database was created."
  value       = aws_lightsail_database.this.created_at
}

output "disk_size" {
  description = "Size of the disk for the database."
  value       = aws_lightsail_database.this.disk_size
}

output "engine" {
  description = "Database software (for example, MySQL)."
  value       = aws_lightsail_database.this.engine
}

output "engine_version" {
  description = "Database engine version (for example, 5.7.23)."
  value       = aws_lightsail_database.this.engine_version
}

output "id" {
  description = "ARN of the database (matches arn)."
  value       = aws_lightsail_database.this.id
}

output "master_endpoint_address" {
  description = "Master endpoint FQDN for the database."
  value       = aws_lightsail_database.this.master_endpoint_address
}

output "master_endpoint_port" {
  description = "Master endpoint network port for the database."
  value       = aws_lightsail_database.this.master_endpoint_port
}

output "ram_size" {
  description = "Amount of RAM in GB for the database."
  value       = aws_lightsail_database.this.ram_size
}

output "secondary_availability_zone" {
  description = "Secondary Availability Zone of a high availability database. The secondary database is used for failover support of a high availability database."
  value       = aws_lightsail_database.this.secondary_availability_zone
}

output "support_code" {
  description = "Support code for the database. Include this code in your email to support when you have questions about a database in Lightsail."
  value       = aws_lightsail_database.this.support_code
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_lightsail_database.this.tags_all
}