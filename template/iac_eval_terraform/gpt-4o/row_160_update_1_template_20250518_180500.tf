provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"

  alarm_description   = "This alarm triggers if CPU utilization exceeds 80% for 10 minutes."
  alarm_actions       = [] # Add ARN of SNS topic or other actions here
  ok_actions          = [] # Add ARN of SNS topic or other actions here
  insufficient_data_actions = [] # Add ARN of SNS topic or other actions here

  dimensions = {
    InstanceId = "i-1234567890abcdef0" # Replace with your EC2 instance ID
  }
}