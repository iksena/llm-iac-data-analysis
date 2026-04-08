data "aws_iam_policy_document" "dashboard" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com",
      ]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "dashboard" {
  name               = "monoweb-prd-dashboard-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.dashboard.json
}
