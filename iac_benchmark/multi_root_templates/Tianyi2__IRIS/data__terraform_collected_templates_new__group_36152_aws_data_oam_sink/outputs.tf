output "arn" {
  description = "ARN of the sink."
  value       = data.aws_oam_sink.this.arn
}

output "id" {
  description = "ARN of the sink. Use arn instead."
  value       = data.aws_oam_sink.this.id
}

output "name" {
  description = "Name of the sink."
  value       = data.aws_oam_sink.this.name
}

output "sink_id" {
  description = "Random ID string that AWS generated as part of the sink ARN."
  value       = data.aws_oam_sink.this.sink_id
}

output "tags" {
  description = "Tags assigned to the sink."
  value       = data.aws_oam_sink.this.tags
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_oam_sink.this.region
}

output "sink_identifier" {
  description = "ARN of the sink."
  value       = data.aws_oam_sink.this.sink_identifier
}