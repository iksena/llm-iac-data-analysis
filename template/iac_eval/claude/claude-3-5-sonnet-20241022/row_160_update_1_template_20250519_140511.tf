provider "aws" {
  region = "us-west-2"
}

# Variables
variable "instance_id" {
  description = "ID of the EC2 instance to monitor"
  type        = string
  default     = "i-1234567890abcdef0" # Replace with your instance ID
}

# CloudWatch Alarm Resource
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "cpu-utilization-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions      = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    InstanceId = var.instance_id
  }
}

# SNS Topic for alarm notifications
resource "aws_sns_topic" "alarm_topic" {
  name = "cpu-alarm-topic"
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.alarm_topic.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.alarm_topic.arn
      }
    ]
  })
}