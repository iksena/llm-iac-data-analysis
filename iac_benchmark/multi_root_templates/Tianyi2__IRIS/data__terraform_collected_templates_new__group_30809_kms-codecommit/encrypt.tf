data "aws_iam_policy_document" "repo_encrypt" {
  statement {
    sid = "1"
    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush"
    ]
    resources = [
      aws_codecommit_repository.secrets_repo.arn
    ]
  }

  statement {
    sid = "2"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = [
      aws_kms_key.sops_key.arn
    ]
  }
}

resource "aws_iam_policy" "repo_encrypt" {
  name = "${var.repo_name}-encrypt"
  policy = data.aws_iam_policy_document.repo_encrypt.json
}

data "aws_iam_policy_document" "repo_encrypt_assumptions" {
  statement {
    principals {
      type = "AWS"
      identifiers = var.encrypt_allowed_users
    }
    actions = [
      "sts:AssumeRole"
    ]

  }
}

resource "aws_iam_role" "repo_encrypt" {
  name = "${var.repo_name}-encrypt"
  assume_role_policy = data.aws_iam_policy_document.repo_encrypt_assumptions.json
}

resource "aws_iam_role_policy_attachment" "repo_encrypt" {
  role       = aws_iam_role.repo_encrypt.name
  policy_arn = aws_iam_policy.repo_encrypt.arn
}