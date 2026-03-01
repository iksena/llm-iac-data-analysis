provider "aws" {
  region = "us-east-1"
}

# Create CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name          = "foobar"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period             = "120"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "This metric monitors EC2 CPU utilization"
  
  insufficient_data_actions = []
  
  dimensions = {
    "Service" = "EC2"
  }
}

# Create Route 53 Health Check
resource "aws_route53_health_check" "cpu_check" {
  type                            = "CLOUDWATCH_METRIC"
  cloudwatch_alarm_name           = aws_cloudwatch_metric_alarm.foobar.alarm_name
  cloudwatch_alarm_region        = "us-east-1"
  insufficient_data_health_status = "Healthy"
  
  tags = {
    Name = "cpu-utilization-health-check"
  }
}