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
  name               = "VengefulVineyardProdServerECSTaskRole"
  assume_role_policy = data.aws_iam_policy_document.server.json
}
