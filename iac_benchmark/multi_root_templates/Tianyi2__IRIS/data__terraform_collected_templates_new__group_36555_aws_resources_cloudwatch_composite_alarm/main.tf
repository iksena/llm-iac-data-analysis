resource "aws_sns_topic" "example" {
  name = "example-topic"
}

resource "aws_cloudwatch_metric_alarm" "alpha" {
  alarm_name          = "alpha-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
}

resource "aws_cloudwatch_metric_alarm" "bravo" {
  alarm_name          = "bravo-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
}

resource "aws_cloudwatch_composite_alarm" "example" {
  alarm_description = "This is a composite alarm!"
  alarm_name        = "example-composite-alarm"

  alarm_actions = aws_sns_topic.example.arn
  ok_actions    = aws_sns_topic.example.arn

  alarm_rule = <<EOF
ALARM(${aws_cloudwatch_metric_alarm.alpha.alarm_name}) OR
ALARM(${aws_cloudwatch_metric_alarm.bravo.alarm_name})
EOF

  actions_suppressor {
    alarm            = "suppressor-alarm"
    extension_period = 10
    wait_period      = 20
  }
}