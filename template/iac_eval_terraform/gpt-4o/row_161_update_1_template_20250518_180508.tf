provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name          = "foobar"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU utilization is greater than or equal to 80% for two consecutive 2-minute periods."
  actions_enabled     = false
  ok_actions          = []
  alarm_actions       = []
  insufficient_data_actions = []

  dimensions = {
    InstanceId = "i-1234567890abcdef0"  # Replace with your actual instance ID
  }
}