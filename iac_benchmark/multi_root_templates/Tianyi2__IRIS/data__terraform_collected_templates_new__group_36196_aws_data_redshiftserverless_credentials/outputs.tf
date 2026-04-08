output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_redshiftserverless_credentials.this.region
}

output "workgroup_name" {
  description = "The name of the workgroup associated with the database."
  value       = data.aws_redshiftserverless_credentials.this.workgroup_name
}

output "db_name" {
  description = "The name of the database to get temporary authorization to log on to."
  value       = data.aws_redshiftserverless_credentials.this.db_name
}

output "duration_seconds" {
  description = "The number of seconds until the returned temporary password expires."
  value       = data.aws_redshiftserverless_credentials.this.duration_seconds
}

output "db_password" {
  description = "Temporary password that authorizes the user name returned by db_user to log on to the database db_name."
  value       = data.aws_redshiftserverless_credentials.this.db_password
  sensitive   = true
}

output "db_user" {
  description = "A database user name that is authorized to log on to the database db_name using the password db_password."
  value       = data.aws_redshiftserverless_credentials.this.db_user
}

output "expiration" {
  description = "Date and time the password in db_password expires."
  value       = data.aws_redshiftserverless_credentials.this.expiration
}