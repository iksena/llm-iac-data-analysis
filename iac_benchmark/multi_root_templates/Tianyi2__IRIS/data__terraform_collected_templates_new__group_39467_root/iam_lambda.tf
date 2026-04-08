resource "aws_iam_role" "s3_webserver_buckets_role" {
  name = "lambda-s3-webserver-buckets"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "Allows Lambda functions to write to CloudWatch"

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

resource "aws_iam_policy" "lambda_put_config_evaluations" {
  name        = "lambda-put-config-evaluations"
  path        = "/"
  description = "Allows Lambda to put an evaluation to AWS Config"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": "config:PutEvaluations",
          "Resource": "*"
      }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "s3_webserver_buckets_cloudwatch" {
  role       = aws_iam_role.s3_webserver_buckets_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "s3_webserver_buckets_attachment_s3readonly" {
  role       = aws_iam_role.s3_webserver_buckets_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "s3_webserver_buckets_attachment_config_putevaluation" {
  role       = aws_iam_role.s3_webserver_buckets_role.name
  policy_arn = aws_iam_policy.lambda_put_config_evaluations.arn
}

resource "aws_iam_role" "iam_console_login_role" {
  name = "lambda-iam-console-login"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "iam_console_login_iam_read_only" {
  role       = aws_iam_role.iam_console_login_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "iam_console_login_cloudwatch" {
  role       = aws_iam_role.iam_console_login_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "iam_console_login_config" {
  role       = aws_iam_role.iam_console_login_role.name
  policy_arn = aws_iam_policy.lambda_put_config_evaluations.arn
}

resource "aws_iam_role" "aws_config_recorder" {
  name = "svc_aws_config_recorder"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

