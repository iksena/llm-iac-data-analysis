resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.name}"
  image_tag_mutability = "${var.image_tag_mutability}"

  image_scanning_configuration {
    scan_on_push = "${var.scan_on_push}"
  }

  tags = merge( 
    var.tags
  )
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  count = var.enable_lifecycle_expiration_policy ? 1 : 0
  repository = aws_ecr_repository.ecr_repository.name
  policy               = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than ${var.expiration_days} days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${var.expiration_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}


