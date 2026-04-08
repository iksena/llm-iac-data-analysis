output "arn" {
  description = "The Amazon Resource Name (ARN) of the User."
  value       = data.aws_connect_user.this.arn
}

output "directory_user_id" {
  description = "The identifier of the user account in the directory used for identity management."
  value       = data.aws_connect_user.this.directory_user_id
}

output "hierarchy_group_id" {
  description = "The identifier of the hierarchy group for the user."
  value       = data.aws_connect_user.this.hierarchy_group_id
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the User separated by a colon (:)."
  value       = data.aws_connect_user.this.id
}

output "identity_info" {
  description = "A block that contains information about the identity of the user."
  value       = data.aws_connect_user.this.identity_info
}

output "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  value       = data.aws_connect_user.this.instance_id
}

output "phone_config" {
  description = "A block that contains information about the phone settings for the user."
  value       = data.aws_connect_user.this.phone_config
}

output "routing_profile_id" {
  description = "The identifier of the routing profile for the user."
  value       = data.aws_connect_user.this.routing_profile_id
}

output "security_profile_ids" {
  description = "A list of identifiers for the security profiles for the user."
  value       = data.aws_connect_user.this.security_profile_ids
}

output "tags" {
  description = "A map of tags to assign to the User."
  value       = data.aws_connect_user.this.tags
}