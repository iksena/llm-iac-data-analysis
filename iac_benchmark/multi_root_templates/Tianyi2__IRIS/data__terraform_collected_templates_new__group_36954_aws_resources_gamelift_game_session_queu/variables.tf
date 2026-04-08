variable "name" {
  description = "Name of the session queue."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_gamelift_game_session_queue, name must not be empty."
  }
}

variable "timeout_in_seconds" {
  description = "Maximum time a game session request can remain in the queue."
  type        = number

  validation {
    condition     = var.timeout_in_seconds > 0
    error_message = "resource_aws_gamelift_game_session_queue, timeout_in_seconds must be greater than 0."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "custom_event_data" {
  description = "Information to be added to all events that are related to this game session queue."
  type        = string
  default     = null
}

variable "destinations" {
  description = "List of fleet/alias ARNs used by session queue for placing game sessions."
  type        = list(string)
  default     = null

  validation {
    condition = var.destinations == null ? true : alltrue([
      for arn in var.destinations : can(regex("^arn:aws:gamelift:", arn))
    ])
    error_message = "resource_aws_gamelift_game_session_queue, destinations must be valid GameLift ARNs."
  }
}

variable "notification_target" {
  description = "An SNS topic ARN that is set up to receive game session placement notifications."
  type        = string
  default     = null

  validation {
    condition     = var.notification_target == null ? true : can(regex("^arn:aws:sns:", var.notification_target))
    error_message = "resource_aws_gamelift_game_session_queue, notification_target must be a valid SNS topic ARN."
  }
}

variable "player_latency_policy" {
  description = "One or more policies used to choose fleet based on player latency."
  type = list(object({
    maximum_individual_player_latency_milliseconds = number
    policy_duration_seconds                        = optional(number)
  }))
  default = null

  validation {
    condition = var.player_latency_policy == null ? true : alltrue([
      for policy in var.player_latency_policy : policy.maximum_individual_player_latency_milliseconds > 0
    ])
    error_message = "resource_aws_gamelift_game_session_queue, player_latency_policy maximum_individual_player_latency_milliseconds must be greater than 0."
  }

  validation {
    condition = var.player_latency_policy == null ? true : alltrue([
      for policy in var.player_latency_policy : policy.policy_duration_seconds == null ? true : policy.policy_duration_seconds > 0
    ])
    error_message = "resource_aws_gamelift_game_session_queue, player_latency_policy policy_duration_seconds must be greater than 0 when specified."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = null
}