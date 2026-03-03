terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create a CloudWatch metric alarm called "foobar"
resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "foobar"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  statistic                 = "Average"
  period                    = 120
  evaluation_periods        = 1
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  threshold                 = 80
  alarm_description         = "Alarm triggered when CPU utilization is too high."
  actions_enabled           = false
}

# Create a Route 53 health check that uses the CloudWatch metric alarm "foobar"
resource "aws_route53_health_check" "health_check" {
  cloudwatch_alarm_configuration {
    alarm_name                        = aws_cloudwatch_metric_alarm.foobar.alarm_name
    alarm_region                      = "us-east-1"
    insufficient_data_health_status   = "Healthy"
  }
}