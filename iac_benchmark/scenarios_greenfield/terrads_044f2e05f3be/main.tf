resource "aws_sqs_queue" "queue" {
  name                              = "${var.name}${var.fifo_queue == true ? ".fifo" : ""}"
  message_retention_seconds         = var.message_retention_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = var.kms_master_key_id == "" ? aws_kms_key.sqs.id : var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  max_message_size                  = var.max_message_size
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter_queue.arn,
    maxReceiveCount     = 3
  })

  tags = var.tags
}

resource "aws_sqs_queue_policy" "queue" {
  queue_url = aws_sqs_queue.queue.id
  policy    = var.policy_queue == "" ? data.aws_iam_policy_document.queue.json : var.policy_queue

  depends_on = [
    aws_sqs_queue.queue
  ]
}

resource "aws_sqs_queue" "deadletter_queue" {
  name                              = "${var.name}-dead-letter-queue${var.fifo_queue == true ? ".fifo" : ""}"
  message_retention_seconds         = var.message_retention_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  kms_master_key_id                 = var.kms_master_key_id == "" ? aws_kms_key.sqs.id : var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  max_message_size                  = var.max_message_size

  tags = var.tags
}
resource "aws_sqs_queue_policy" "deadletter_queue" {
  queue_url = aws_sqs_queue.deadletter_queue.id
  policy    = var.policy_deadletter_queue == "" ? data.aws_iam_policy_document.deadletter_queue.json : var.policy_deadletter_queue

  depends_on = [
    aws_sqs_queue.deadletter_queue
  ]


}
##### KMS Key for SQS #####
resource "aws_kms_key" "sqs" {
  description         = "KMS para a fila SQS - ${var.name}"
  enable_key_rotation = true

  tags = var.tags
}
resource "aws_kms_alias" "sqs" {
  name          = "alias/sqs-${var.name}"
  target_key_id = join("", aws_kms_key.sqs.*.id)

  depends_on = [
    aws_kms_key.sqs
  ]
}
##### KMS Key for SQS - FIM #####

resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name          = "${aws_sqs_queue.queue.name}-flood-alarm"
  alarm_description   = "The ${aws_sqs_queue.queue.name} main queue has a large number of queued items"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 300



  statistic          = "Average"
  threshold          = var.allowed_items_max
  treat_missing_data = "notBreaching"
  alarm_actions      = [var.alarm_sns_topic_arn == "" ? aws_sns_topic.alarm[0].arn : var.alarm_sns_topic_arn]
  dimensions = {
    "QueueName" = aws_sqs_queue.queue.name
  }
  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "deadletter_alarm" {
  alarm_name          = "${aws_sqs_queue.deadletter_queue.name}-not-empty-alarm"
  alarm_description   = "Items are on the ${aws_sqs_queue.deadletter_queue.name} queue"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Average"
  threshold           = 15
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.alarm_sns_topic_arn == "" ? aws_sns_topic.alarm[0].arn : var.alarm_sns_topic_arn]
  dimensions = {
    "QueueName" = aws_sqs_queue.deadletter_queue.name
  }
  tags = var.tags
}

##### KMS Key for SNS #####
resource "aws_kms_key" "sns" {
  description         = "KMS para o topico SNS - ${var.name}"
  enable_key_rotation = true

  tags = var.tags
}

resource "aws_kms_alias" "sns" {
  name          = "alias/sns-${var.name}"
  target_key_id = join("", aws_kms_key.sns.*.id)

  depends_on = [
    aws_kms_key.sns
  ]
}
##### KMS Key for SNS - FIM #####

resource "aws_sns_topic" "alarm" {
  count             = var.alarm_sns_topic_arn == "" ? 1 : 0
  name              = "${var.name}-alarm-topic"
  kms_master_key_id = var.kms_master_key_id_sns == "" ? aws_kms_key.sns.id : var.kms_master_key_id_sns

  depends_on = [
    aws_sqs_queue.queue
  ]

  tags = var.tags
}

resource "aws_sns_topic_subscription" "alarm" {
  count     = var.alarm_sns_topic_arn == "" ? 1 : 0
  topic_arn = aws_sns_topic.alarm[0].arn
  protocol  = "email"
  endpoint  = var.email
}

resource "aws_sns_topic_policy" "alarm" {
  arn    = aws_sns_topic.alarm[0].arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}