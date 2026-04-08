output "arn" {
  description = "Amazon Resource Name (ARN) of the Canary"
  value       = aws_synthetics_canary.this.arn
}

output "engine_arn" {
  description = "ARN of the Lambda function that is used as your canary's engine"
  value       = aws_synthetics_canary.this.engine_arn
}

output "id" {
  description = "Name for this canary"
  value       = aws_synthetics_canary.this.id
}

output "source_location_arn" {
  description = "ARN of the Lambda layer where Synthetics stores the canary script code"
  value       = aws_synthetics_canary.this.source_location_arn
}

output "status" {
  description = "Canary status"
  value       = aws_synthetics_canary.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_synthetics_canary.this.tags_all
}

output "timeline" {
  description = "Structure that contains information about when the canary was created, modified, and most recently run"
  value       = aws_synthetics_canary.this.timeline
}

output "timeline_created" {
  description = "Date and time the canary was created"
  value       = aws_synthetics_canary.this.timeline.0.created
}

output "timeline_last_modified" {
  description = "Date and time the canary was most recently modified"
  value       = aws_synthetics_canary.this.timeline.0.last_modified
}

output "timeline_last_started" {
  description = "Date and time that the canary's most recent run started"
  value       = aws_synthetics_canary.this.timeline.0.last_started
}

output "timeline_last_stopped" {
  description = "Date and time that the canary's most recent run ended"
  value       = aws_synthetics_canary.this.timeline.0.last_stopped
}

output "vpc_config" {
  description = "VPC configuration for the canary"
  value       = var.vpc_config != null ? aws_synthetics_canary.this.vpc_config : []
}

output "vpc_config_vpc_id" {
  description = "ID of the VPC where this canary is to run"
  value       = var.vpc_config != null && length(aws_synthetics_canary.this.vpc_config) > 0 ? aws_synthetics_canary.this.vpc_config[0].vpc_id : null
}