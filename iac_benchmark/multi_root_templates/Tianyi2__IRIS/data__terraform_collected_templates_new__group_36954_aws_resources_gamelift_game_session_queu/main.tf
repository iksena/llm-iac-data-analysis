resource "aws_gamelift_game_session_queue" "this" {
  name                = var.name
  timeout_in_seconds  = var.timeout_in_seconds
  region              = var.region
  custom_event_data   = var.custom_event_data
  destinations        = var.destinations
  notification_target = var.notification_target
  tags                = var.tags

  dynamic "player_latency_policy" {
    for_each = var.player_latency_policy != null ? var.player_latency_policy : []
    content {
      maximum_individual_player_latency_milliseconds = player_latency_policy.value.maximum_individual_player_latency_milliseconds
      policy_duration_seconds                        = player_latency_policy.value.policy_duration_seconds
    }
  }
}