resource "aws_sqs_queue" "sqs-queue" {

  name = local.aws_sqs_queue

  // set to the default values
  fifo_queue                 = false
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144
  receive_wait_time_seconds  = 0
  sqs_managed_sse_enabled    = true
}

resource "aws_sqs_queue_policy" "sqs-queue-policy" {
  queue_url = aws_sqs_queue.sqs-queue.id

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "__default_policy_ID",
    "Statement" : [
      {
        "Sid" : "__owner_statement",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "${data.aws_caller_identity.current.account_id}"
        },
        "Action" : [
          "SQS:*"
        ],
        "Resource" : "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:"
      },
      {
        "Sid" : "allow-crawl-user",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "${aws_iam_user.iam-user.arn}"
          ]
        },
        "Action" : "sqs:*",
        "Resource" : "${aws_sqs_queue.sqs-queue.arn}"
      },
      {
        "Sid" : "allow-event-bus-rule",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "events.amazonaws.com"
          ]
        },
        "Action" : "sqs:SendMessage",
        "Resource" : "${aws_sqs_queue.sqs-queue.arn}",
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : "${aws_cloudwatch_event_rule.kscope_crawler_rule.arn}"
          }
        }
      }
    ]
  })

}
