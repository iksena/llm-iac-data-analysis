data "aws_iam_policy_document" "server" {
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

resource "aws_iam_role" "server" {
  name               = "grades-prod-server-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.server.json
}

data "aws_iam_policy_document" "web" {
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

resource "aws_iam_role" "web" {
  name               = "grades-prod-web-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.web.json
}
