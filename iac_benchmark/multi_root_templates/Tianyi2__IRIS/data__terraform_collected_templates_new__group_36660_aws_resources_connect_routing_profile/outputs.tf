output "arn" {
  description = "The Amazon Resource Name (ARN) of the Routing Profile."
  value       = aws_connect_routing_profile.this.arn
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the Routing Profile separated by a colon (:)."
  value       = aws_connect_routing_profile.this.id
}

output "routing_profile_id" {
  description = "The identifier for the Routing Profile."
  value       = aws_connect_routing_profile.this.routing_profile_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_routing_profile.this.tags_all
}

output "queue_configs" {
  description = "In addition to the arguments used in the queue_configs argument block, there are additional attributes exported within the queue_configs block."
  value = [
    for qc in aws_connect_routing_profile.this.queue_configs : {
      channel    = qc.channel
      delay      = qc.delay
      priority   = qc.priority
      queue_id   = qc.queue_id
      queue_arn  = qc.queue_arn
      queue_name = qc.queue_name
    }
  ]
}