resource "aws_scheduler_schedule" "ec2_start" {
  for_each = {
    for k, v in local.ec2_map : k => v
    if v.region == "eu-west-1"
  }
  provider = aws.dublin

  name                = "${each.key}-start"
  description         = "Start ${each.key} at ${each.value.start_time}"
  schedule_expression = "cron(0 ${each.value.start_time} ? * MON-FRI *)"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.eventbridge_ec2_role.arn

    input = jsonencode({
      InstanceIds = [
        aws_instance.ec2_dub[each.key].id
      ]
    })
    retry_policy {
      maximum_event_age_in_seconds = 60
      maximum_retry_attempts       = 2
    }
  }
  depends_on = [aws_instance.ec2_dub]
}

resource "aws_scheduler_schedule" "ec2_stop" {
  for_each = {
    for k, v in local.ec2_map : k => v
    if v.region == "eu-west-1"
  }
  provider = aws.dublin

  name                = "${each.key}-stop"
  description         = "Stop ${each.key} at ${each.value.shutdown_time}"
  schedule_expression = "cron(0 ${each.value.shutdown_time} ? * MON-FRI *)"
  flexible_time_window {
    mode = "OFF"
  }
  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.eventbridge_ec2_role.arn

    input = jsonencode({
      InstanceIds = [
        aws_instance.ec2_dub[each.key].id
      ]
    })
    retry_policy {
      maximum_event_age_in_seconds = 60
      maximum_retry_attempts       = 2
    }
  }
  depends_on = [aws_instance.ec2_dub]
}