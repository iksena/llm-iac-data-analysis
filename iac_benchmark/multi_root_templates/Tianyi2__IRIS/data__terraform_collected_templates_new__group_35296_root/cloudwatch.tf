resource "aws_cloudwatch_event_rule" "eni_attach" {
  name        = "${var.cloudwatch_event_rule_name}"
  description = "Trigger for lambda ENI attach"

  event_pattern = <<PATTERN
{
  "detail-type": [
    "EC2 Instance-launch Lifecycle Action"
  ],
  "source": [
    "aws.autoscaling"
  ],
  "detail": {
    "AutoScalingGroupName": [
      "${var.asg_name}"
    ],
    "LifecycleHookName": [
      "lambda-eni-attach"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "eni_attach" {
  rule = "${aws_cloudwatch_event_rule.eni_attach.name}"
  arn  = "${aws_lambda_function.eni_attach.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_eni-attach" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.eni_attach.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.eni_attach.arn}"
}
