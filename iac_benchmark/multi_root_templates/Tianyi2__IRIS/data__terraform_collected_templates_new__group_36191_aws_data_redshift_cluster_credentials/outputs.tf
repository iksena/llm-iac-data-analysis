output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_redshift_cluster_credentials.this.region
}

output "auto_create" {
  description = "Create a database user with the name specified for the user named in db_user if one does not exist."
  value       = data.aws_redshift_cluster_credentials.this.auto_create
}

output "cluster_identifier" {
  description = "Unique identifier of the cluster that contains the database for which your are requesting credentials."
  value       = data.aws_redshift_cluster_credentials.this.cluster_identifier
}

output "db_name" {
  description = "Name of a database that DbUser is authorized to log on to."
  value       = data.aws_redshift_cluster_credentials.this.db_name
}

output "db_user" {
  description = "Name of a database user."
  value       = data.aws_redshift_cluster_credentials.this.db_user
}

output "db_groups" {
  description = "List of the names of existing database groups that the user named in db_user will join for the current session."
  value       = data.aws_redshift_cluster_credentials.this.db_groups
}

output "duration_seconds" {
  description = "The number of seconds until the returned temporary password expires."
  value       = data.aws_redshift_cluster_credentials.this.duration_seconds
}

output "db_password" {
  description = "Temporary password that authorizes the user name returned by db_user to log on to the database db_name."
  value       = data.aws_redshift_cluster_credentials.this.db_password
  sensitive   = true
}

output "expiration" {
  description = "Date and time the password in db_password expires."
  value       = data.aws_redshift_cluster_credentials.this.expiration
}