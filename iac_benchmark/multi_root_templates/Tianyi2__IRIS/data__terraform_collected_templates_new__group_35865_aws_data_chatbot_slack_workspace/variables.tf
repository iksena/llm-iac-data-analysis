variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "slack_team_name" {
  description = "Slack workspace name configured with AWS Chatbot."
  type        = string

  validation {
    condition     = length(var.slack_team_name) > 0
    error_message = "data_aws_chatbot_slack_workspace, slack_team_name must not be empty."
  }
}