resource "aws_iam_role" "role" {
  name = "${var.resources_name}-${var.env}-ecs-services-scheduler-lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "allow_s3_policy" {
  name = "${var.resources_name}-${var.env}-ecs-services-scheduler-allow-lambda-s3"
  role = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.ecs_services_scheduler.arn}/*",
          "${aws_s3_bucket.ecs_services_scheduler.arn}/"
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy" "allow_ecs_policy" {
  name = "${var.resources_name}-${var.env}-ecs-services-scheduler-allow-ecs"
  role = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:ListClusters",
          "ecs:ListServices"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "allow_logs_policy" {
  name = "${var.resources_name}-${var.env}-ecs-services-scheduler-allow-logs"
  role = aws_iam_role.role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:logs:*:*:*"]
      },
    ]
  })
}
