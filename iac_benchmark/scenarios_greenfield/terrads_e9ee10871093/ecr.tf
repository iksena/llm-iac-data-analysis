resource "aws_ecr_repository" "web_backend" {
  name                 = var.application_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

resource "aws_ecr_lifecycle_policy" "web_backend" {
  repository = aws_ecr_repository.web_backend.name
  policy     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 14 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 14
      },
      "action": {
          "type": "expire"
      }
    }
  ]
}
EOF
}
