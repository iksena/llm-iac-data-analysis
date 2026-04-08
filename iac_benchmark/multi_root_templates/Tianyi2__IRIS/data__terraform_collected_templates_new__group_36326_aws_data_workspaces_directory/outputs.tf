output "id" {
  description = "WorkSpaces directory identifier"
  value       = data.aws_workspaces_directory.this.id
}

output "active_directory_config" {
  description = "Configuration for Active Directory integration when workspace_type is set to POOLS"
  value       = data.aws_workspaces_directory.this.active_directory_config
}

output "alias" {
  description = "Directory alias"
  value       = data.aws_workspaces_directory.this.alias
}

output "customer_user_name" {
  description = "User name for the service account"
  value       = data.aws_workspaces_directory.this.customer_user_name
}

output "directory_name" {
  description = "Name of the directory"
  value       = data.aws_workspaces_directory.this.directory_name
}

output "directory_type" {
  description = "Directory type"
  value       = data.aws_workspaces_directory.this.directory_type
}

output "dns_ip_addresses" {
  description = "IP addresses of the DNS servers for the directory"
  value       = data.aws_workspaces_directory.this.dns_ip_addresses
}

output "iam_role_id" {
  description = "Identifier of the IAM role. This is the role that allows Amazon WorkSpaces to make calls to other services, such as Amazon EC2, on your behalf"
  value       = data.aws_workspaces_directory.this.iam_role_id
}

output "ip_group_ids" {
  description = "Identifiers of the IP access control groups associated with the directory"
  value       = data.aws_workspaces_directory.this.ip_group_ids
}

output "registration_code" {
  description = "Registration code for the directory. This is the code that users enter in their Amazon WorkSpaces client application to connect to the directory"
  value       = data.aws_workspaces_directory.this.registration_code
}

output "self_service_permissions" {
  description = "The permissions to enable or disable self-service capabilities"
  value       = data.aws_workspaces_directory.this.self_service_permissions
}

output "subnet_ids" {
  description = "Identifiers of the subnets where the directory resides"
  value       = data.aws_workspaces_directory.this.subnet_ids
}

output "tags" {
  description = "A map of tags assigned to the WorkSpaces directory"
  value       = data.aws_workspaces_directory.this.tags
}

output "user_identity_type" {
  description = "The user identity type for the WorkSpaces directory"
  value       = data.aws_workspaces_directory.this.user_identity_type
}

output "workspace_access_properties" {
  description = "Specifies which devices and operating systems users can use to access their WorkSpaces"
  value       = data.aws_workspaces_directory.this.workspace_access_properties
}

output "workspace_creation_properties" {
  description = "The default properties that are used for creating WorkSpaces"
  value       = data.aws_workspaces_directory.this.workspace_creation_properties
}

output "workspace_directory_description" {
  description = "The description of the WorkSpaces directory when workspace_type is set to POOLS"
  value       = data.aws_workspaces_directory.this.workspace_directory_description
}

output "workspace_directory_name" {
  description = "The name of the WorkSpaces directory when workspace_type is set to POOLS"
  value       = data.aws_workspaces_directory.this.workspace_directory_name
}

output "workspace_security_group_id" {
  description = "The identifier of the security group that is assigned to new WorkSpaces"
  value       = data.aws_workspaces_directory.this.workspace_security_group_id
}

output "workspace_type" {
  description = "The type of WorkSpaces directory"
  value       = data.aws_workspaces_directory.this.workspace_type
}