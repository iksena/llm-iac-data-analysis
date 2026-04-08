# Lambda role
resource "aws_iam_role" "lambda_role" {
  name_prefix = "${var.lambda_function_name}-"
  description = "Role used by lambda function that attaches ENI to ${var.service} ASG instances"

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

# Lambda policy for managing logs
resource "aws_iam_role_policy" "lambda_logging_policy" {
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

# Lambda policy for attaching ENI
resource "aws_iam_role_policy" "lambda_eni_attach_policy" {
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DetachNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:DescribeInstances",
        "autoscaling:CompleteLifecycleAction"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
