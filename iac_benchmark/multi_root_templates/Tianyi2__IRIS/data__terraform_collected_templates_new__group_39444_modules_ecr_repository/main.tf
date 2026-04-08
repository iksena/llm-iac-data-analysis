resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.repository_name
  image_tag_mutability = "IMMUTABLE"

  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_rule" {
  repository = aws_ecr_repository.ecr_repository.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 10 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPatternList": ["*"],
                "countType": "imageCountMoreThan",
                "countNumber": 10
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_repository_policy" "ecr_repository_policy" {
  repository = aws_ecr_repository.ecr_repository.name
  policy     = data.aws_iam_policy_document.ecr_repository_policy.json
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "ecr_repository_policy" {
  # taken from https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-images.html
  statement {
    sid = "allow_lambda_read"
    principals {
      identifiers = formatlist("arn:aws:iam::%s:root", var.allow_read_account_id_list)
      type        = "AWS"
    }
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
  }

  statement {
    sid = "allow_lambda_service_image_optimization_and_caching"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    condition {
      test     = "StringLike"
      variable = "aws:sourceArn"
      values   = formatlist("arn:aws:lambda:${data.aws_region.current.region}:%s:function:*", var.allow_read_account_id_list)
    }
  }
}
