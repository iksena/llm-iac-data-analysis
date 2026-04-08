data "aws_iam_policy_document" "deployment_requirements" {
  statement {
    actions   = ["ecs:DescribeTaskDefinition", "ecs:RegisterTaskDefinition", "ecs:TagResource"]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = ["iam:PassRole"]
    effect  = "Allow"
    resources = [
      var.task_role_arn,
      data.aws_iam_role.ecs_task_execution_role.arn,
    ]
  }
  statement {
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices",
    ]
    effect = "Allow"
    resources = [
      aws_ecs_service.this.id
    ]
  }
}
