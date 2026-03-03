provider "aws" {
  region = "us-west-2"
}

# Create CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name          = "foobar"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = "120"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "This metric monitors EC2 CPU utilization"
  
  # No actions will be taken when there's insufficient data
  insufficient_data_actions = []
  
  dimensions = {
    InstanceId = "*"  # This will monitor all EC2 instances
  }
}