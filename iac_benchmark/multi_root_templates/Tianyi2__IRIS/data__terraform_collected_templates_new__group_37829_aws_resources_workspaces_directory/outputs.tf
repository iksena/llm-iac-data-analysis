output "id" {
  description = "The WorkSpaces directory identifier"
  value       = aws_workspaces_directory.this.id
}

output "alias" {
  description = "The directory alias"
  value       = aws_workspaces_directory.this.alias
}

output "customer_user_name" {
  description = "The user name for the service account"
  value       = aws_workspaces_directory.this.customer_user_name
}

output "directory_name" {
  description = "The name of the directory"
  value       = aws_workspaces_directory.this.directory_name
}

output "directory_type" {
  description = "The directory type"
  value       = aws_workspaces_directory.this.directory_type
}

output "dns_ip_addresses" {
  description = "The IP addresses of the DNS servers for the directory"
  value       = aws_workspaces_directory.this.dns_ip_addresses
}

output "iam_role_id" {
  description = "The identifier of the IAM role. This is the role that allows Amazon WorkSpaces to make calls to other services, such as Amazon EC2, on your behalf"
  value       = aws_workspaces_directory.this.iam_role_id
}

output "ip_group_ids" {
  description = "The identifiers of the IP access control groups associated with the directory"
  value       = aws_workspaces_directory.this.ip_group_ids
}

output "registration_code" {
  description = "The registration code for the directory. This is the code that users enter in their Amazon WorkSpaces client application to connect to the directory"
  value       = aws_workspaces_directory.this.registration_code
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_workspaces_directory.this.tags_all
}

output "workspace_security_group_id" {
  description = "The identifier of the security group that is assigned to new WorkSpaces"
  value       = aws_workspaces_directory.this.workspace_security_group_id
}