variable "env" {
  description = "The environment you wish to use"
  default     = "dev"
}

variable "aws_account_id" {
  description = "Amazon Web Service Account ID"
  default     = "000000000000"
}

variable "aws_assume_role_arn" {
  description = "IAM Role to assume on AWS"
  default     = "unused"
}

variable "slack_alert_sns_arn" {
  description = "The ARN of sns topic for slack alerts"
  default     = "arn:aws:sns:eu-west-1:000000000000:benchmark-slack-alerts"
}
