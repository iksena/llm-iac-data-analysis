provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers if CPU utilization is greater than 80% for 5 minutes."
  actions_enabled     = false
  dimensions = {
    InstanceId = "i-1234567890abcdef0"
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_read_ops_alarm" {
  alarm_name          = "HighDiskReadOps"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "DiskReadOps"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1000
  alarm_description   = "This alarm triggers if Disk Read Ops is greater than 1000 for 5 minutes."
  actions_enabled     = false
  dimensions = {
    InstanceId = "i-1234567890abcdef0"
  }
}

resource "aws_cloudwatch_composite_alarm" "composite_alarm" {
  alarm_name        = "CompositeAlarmExample"
  alarm_description = "This composite alarm triggers if either the CPU utilization is high or Disk Read Ops is high."
  alarm_rule        = "ALARM(${aws_cloudwatch_metric_alarm.cpu_utilization_alarm.alarm_name}) OR ALARM(${aws_cloudwatch_metric_alarm.disk_read_ops_alarm.alarm_name})"
}