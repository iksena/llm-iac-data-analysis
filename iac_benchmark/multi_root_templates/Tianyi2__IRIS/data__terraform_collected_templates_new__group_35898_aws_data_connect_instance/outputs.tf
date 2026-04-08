output "created_time" {
  description = "When the instance was created."
  value       = data.aws_connect_instance.this.created_time
}

output "arn" {
  description = "ARN of the instance."
  value       = data.aws_connect_instance.this.arn
}

output "identity_management_type" {
  description = "Specifies The identity management type attached to the instance."
  value       = data.aws_connect_instance.this.identity_management_type
}

output "inbound_calls_enabled" {
  description = "Whether inbound calls are enabled."
  value       = data.aws_connect_instance.this.inbound_calls_enabled
}

output "outbound_calls_enabled" {
  description = "Whether outbound calls are enabled."
  value       = data.aws_connect_instance.this.outbound_calls_enabled
}

output "early_media_enabled" {
  description = "Whether early media for outbound calls is enabled."
  value       = data.aws_connect_instance.this.early_media_enabled
}

output "contact_flow_logs_enabled" {
  description = "Whether contact flow logs are enabled."
  value       = data.aws_connect_instance.this.contact_flow_logs_enabled
}

output "contact_lens_enabled" {
  description = "Whether contact lens is enabled."
  value       = data.aws_connect_instance.this.contact_lens_enabled
}

output "multi_party_conference_enabled" {
  description = "Whether multi-party calls/conference is enabled."
  value       = data.aws_connect_instance.this.multi_party_conference_enabled
}

output "status" {
  description = "State of the instance."
  value       = data.aws_connect_instance.this.status
}

output "service_role" {
  description = "Service role of the instance."
  value       = data.aws_connect_instance.this.service_role
}

output "tags" {
  description = "A map of tags to assigned to the instance."
  value       = data.aws_connect_instance.this.tags
}

output "region" {
  description = "Region where the resource is managed."
  value       = data.aws_connect_instance.this.region
}

output "instance_id" {
  description = "Connect instance ID."
  value       = data.aws_connect_instance.this.instance_id
}

output "instance_alias" {
  description = "Connect instance alias."
  value       = data.aws_connect_instance.this.instance_alias
}