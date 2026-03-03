provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_log_group" "route53_log_group" {
  name = "aws_route53_example_com"
}

resource "aws_iam_role" "route53_logging_role" {
  name = "route53-query-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "route53_logging_policy" {
  name   = "route53-query-logging-policy"
  role   = aws_iam_role.route53_logging_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = aws_cloudwatch_log_group.route53_log_group.arn
      }
    ]
  })
}

resource "aws_route53_zone" "primary" {
  name = "primary"
}

resource "aws_route53_query_log" "query_log" {
  zone_id           = aws_route53_zone.primary.zone_id
  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53_log_group.arn
  cloudwatch_log_role_arn  = aws_iam_role.route53_logging_role.arn
}