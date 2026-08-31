data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${replace(title(local.prefix), "-", "")}EcsExecution"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_01" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_task_execution_02" {
  role = aws_iam_role.ecs_task_execution.id
  name = "GetParameter"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
        ]
        Resource = [
          aws_ssm_parameter.app_db_user_pass.arn,
          aws_ssm_parameter.migrate_db_user_pass.arn,
        ]
      },
    ]
  })
}