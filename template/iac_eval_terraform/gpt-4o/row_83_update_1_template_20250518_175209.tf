provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name          = "foobar"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    InstanceId = "i-1234567890abcdef0"  # Replace with your EC2 instance ID
  }
}

resource "aws_route53_health_check" "example" {
  type = "CLOUDWATCH_METRIC"

  cloudwatch_config {
    alarm_name = aws_cloudwatch_metric_alarm.foobar.alarm_name
    alarm_region = "us-east-1"
  }

  insufficient_data_health_status = "Healthy"
}