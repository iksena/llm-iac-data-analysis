# ── main.tf ────────────────────────────────────
# This aws_lambda_function is used when invoked with a local zipfile
resource "aws_lambda_function" "local_zipfile" {
  count = "${var.function_s3_bucket == "" ? 1 : 0}"

  # These are SPECIFIC to the deployment method:
  filename         = "${var.function_zipfile}"
  source_code_hash = "${var.function_s3_bucket == "" ? "${base64sha256(file("${var.function_zipfile}"))}" : ""}"

  # These are the SAME for both:
  description   = "${var.comment_prefix}${var.cronjob_name}"
  function_name = "${local.prefix_with_name}"
  handler       = "${var.function_handler}"
  runtime       = "${var.function_runtime}"
  timeout       = "${var.function_timeout}"
  memory_size   = "${var.memory_size}"
  role          = "${aws_iam_role.this.arn}"
  tags          = "${var.tags}"

  environment {
    variables = "${var.function_env_vars}"
  }
}

# This aws_lambda_function is used when invoked with a zipfile in S3
resource "aws_lambda_function" "s3_zipfile" {
  count = "${var.function_s3_bucket == "" ? 0 : 1}"

  # These are SPECIFIC to the deployment method:
  s3_bucket = "${var.function_s3_bucket}"
  s3_key    = "${var.function_zipfile}"

  # These are the SAME for both:
  description   = "${var.comment_prefix}${var.cronjob_name}"
  function_name = "${local.prefix_with_name}"
  handler       = "${var.function_handler}"
  runtime       = "${var.function_runtime}"
  timeout       = "${var.function_timeout}"
  memory_size   = "${var.memory_size}"
  role          = "${aws_iam_role.this.arn}"
  tags          = "${var.tags}"

  environment {
    variables = "${var.function_env_vars}"
  }
}

# Terraform isn't particularly helpful when you want to depend on the existence of a resource which may have count 0 or 1, like our functions.
# This is a hacky way of referring to the properties of the function, regardless of which one got created.
# https://github.com/hashicorp/terraform/issues/16580#issuecomment-342573652
locals {
  function_id         = "${element(concat(aws_lambda_function.local_zipfile.*.id, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.id, list("")), 0)}"
  function_arn        = "${element(concat(aws_lambda_function.local_zipfile.*.arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.arn, list("")), 0)}"
  function_invoke_arn = "${element(concat(aws_lambda_function.local_zipfile.*.invoke_arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.invoke_arn, list("")), 0)}"
}


# ── variables.tf ────────────────────────────────────
variable "cronjob_name" {
  description = "Name which will be used to create your Lambda function (e.g. `\"my-important-cronjob\"`)"
}

variable "name_prefix" {
  description = "Name prefix to use for objects that need to be created (only lowercase alphanumeric characters and hyphens allowed, for S3 bucket name compatibility)"
  default     = "aws-lambda-cronjob---"
}

variable "comment_prefix" {
  description = "This will be included in comments for resources that are created"
  default     = "Lambda Cronjob: "
}

variable "schedule_expression" {
  description = "How often to run the Lambda (see https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html); e.g. `\"rate(15 minutes)\"` or `\"cron(0 12 * * ? *)\"`"
  default     = "rate(60 minutes)"
}

variable "function_zipfile" {
  description = "Path to a ZIP file that will be installed as the Lambda function (e.g. `\"my-cronjob.zip\"`)"
}

variable "function_s3_bucket" {
  description = "When provided, the zipfile is retrieved from an S3 bucket by this name instead (filename is still provided via `function_zipfile`)"
  default     = ""
}

variable "function_handler" {
  description = "Instructs Lambda on which function to invoke within the ZIP file"
  default     = "index.handler"
}

variable "function_timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = 128
}

variable "function_runtime" {
  description = "Which node.js version should Lambda use for this function"
  default     = "nodejs8.10"
}

variable "function_env_vars" {
  description = "Which env vars (if any) to invoke the Lambda with"
  type        = "map"

  default = {
    # This effectively useless, but an empty map can't be used in the "aws_lambda_function" resource
    # -> this is 100% safe to override with your own env, should you need one
    aws_lambda_cronjob = ""
  }
}

variable "lambda_logging_enabled" {
  description = "When true, writes any console output to the Lambda function's CloudWatch group"
  default     = false
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = "map"
  default     = {}
}

locals {
  prefix_with_name = "${var.name_prefix}${replace("${var.cronjob_name}", "/[^a-z0-9-]+/", "-")}" # only lowercase alphanumeric characters and hyphens are allowed in e.g. S3 bucket names
}


# ── outputs.tf ────────────────────────────────────
output "function_name" {
  description = "This is the unique name of the Lambda function that was created"
  value       = "${local.function_id}"
}


# ── permissions.tf ────────────────────────────────────
# Allow Lambda to invoke our functions:

resource "aws_iam_role" "this" {
  name = "${local.prefix_with_name}"
  tags = "${var.tags}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Allow writing logs to CloudWatch from our functions:

resource "aws_iam_policy" "this" {
  count = "${var.lambda_logging_enabled ? 1 : 0}"
  name  = "${local.prefix_with_name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = "${var.lambda_logging_enabled ? 1 : 0}"
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${aws_iam_policy.this.arn}"
}

# Add the scheduled execution rules & permissions:

resource "aws_cloudwatch_event_rule" "this" {
  name                = "${local.prefix_with_name}---scheduled-invocation"
  schedule_expression = "${var.schedule_expression}"
  tags                = "${var.tags}"
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = "${aws_cloudwatch_event_rule.this.name}"
  target_id = "${aws_cloudwatch_event_rule.this.name}"
  arn       = "${local.function_arn}"
}

resource "aws_lambda_permission" "this" {
  statement_id  = "${local.prefix_with_name}---scheduled-invocation"
  action        = "lambda:InvokeFunction"
  function_name = "${local.function_id}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.this.arn}"
}
