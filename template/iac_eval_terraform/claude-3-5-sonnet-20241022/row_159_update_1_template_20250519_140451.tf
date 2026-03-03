provider "aws" {
  region = "us-east-1"
}

# Create an SNS topic for alarm notifications
resource "aws_sns_topic" "alarm_topic" {
  name = "cloudwatch-composite-alarm-topic"
}

# Create a CPU utilization metric alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/EC2"
  period             = "300"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "This metric monitors EC2 CPU utilization"
  alarm_actions      = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    InstanceId = "i-example" # Replace with actual instance ID or remove dimensions if not needed
  }
}

# Create a memory utilization metric alarm
resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name          = "high-memory-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name        = "MemoryUtilization"
  namespace          = "CWAgent"
  period             = "300"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "This metric monitors memory utilization"
  alarm_actions      = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    InstanceId = "i-example" # Replace with actual instance ID or remove dimensions if not needed
  }
}

# Create the composite alarm
resource "aws_cloudwatch_composite_alarm" "composite_alarm" {
  alarm_name = "composite-system-alarm"
  alarm_description = "Composite alarm that monitors both CPU and Memory"
  alarm_actions = [aws_sns_topic.alarm_topic.arn]

  alarm_rule = "ALARM(${aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name}) OR ALARM(${aws_cloudwatch_metric_alarm.memory_alarm.alarm_name})"

  depends_on = [
    aws_cloudwatch_metric_alarm.cpu_alarm,
    aws_cloudwatch_metric_alarm.memory_alarm
  ]
}

# IAM role for CloudWatch
resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-composite-alarm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for CloudWatch
resource "aws_iam_role_policy" "cloudwatch_policy" {
  name = "cloudwatch-composite-alarm-policy"
  role = aws_iam_role.cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutCompositeAlarm",
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}