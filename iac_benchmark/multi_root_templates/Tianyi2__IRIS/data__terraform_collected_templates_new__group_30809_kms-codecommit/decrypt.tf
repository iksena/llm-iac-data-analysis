data "aws_iam_policy_document" "repo_decrypt" {
  statement {
    sid = "1"
    actions = [
      "codecommit:GitPull",
    ]
    resources = [
      aws_codecommit_repository.secrets_repo.arn
    ]
  }

  statement {
    sid = "2"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.sops_key.arn
    ]
  }
}

resource "aws_iam_policy" "repo_decrypt" {
  name = "${var.repo_name}-decrypt"
  policy = data.aws_iam_policy_document.repo_decrypt.json
}

data "aws_iam_policy_document" "repo_decrypt_assumptions" {
  statement {
    principals {
      type = "AWS"
      identifiers = var.decrypt_allowed_users
    }
    actions = [
      "sts:AssumeRole"
    ]

  }
}

resource "aws_iam_role" "repo_decrypt" {
  name = "${var.repo_name}-decrypt"
  assume_role_policy = data.aws_iam_policy_document.repo_decrypt_assumptions.json
}

resource "aws_iam_role_policy_attachment" "repo_decrypt" {
  role       = aws_iam_role.repo_decrypt.name
  policy_arn = aws_iam_policy.repo_decrypt.arn
}