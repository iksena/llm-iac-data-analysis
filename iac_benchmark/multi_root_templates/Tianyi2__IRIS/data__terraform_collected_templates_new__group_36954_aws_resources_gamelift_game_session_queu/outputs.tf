output "arn" {
  description = "Game Session Queue ARN."
  value       = aws_gamelift_game_session_queue.this.arn
}

output "name" {
  description = "Name of the session queue."
  value       = aws_gamelift_game_session_queue.this.name
}

output "timeout_in_seconds" {
  description = "Maximum time a game session request can remain in the queue."
  value       = aws_gamelift_game_session_queue.this.timeout_in_seconds
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_gamelift_game_session_queue.this.region
}

output "custom_event_data" {
  description = "Information added to all events that are related to this game session queue."
  value       = aws_gamelift_game_session_queue.this.custom_event_data
}

output "destinations" {
  description = "List of fleet/alias ARNs used by session queue for placing game sessions."
  value       = aws_gamelift_game_session_queue.this.destinations
}

output "notification_target" {
  description = "SNS topic ARN that receives game session placement notifications."
  value       = aws_gamelift_game_session_queue.this.notification_target
}

output "player_latency_policy" {
  description = "Policies used to choose fleet based on player latency."
  value       = aws_gamelift_game_session_queue.this.player_latency_policy
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_gamelift_game_session_queue.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_gamelift_game_session_queue.this.tags_all
}