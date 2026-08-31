/* # Create a ECR Repository
resource "aws_ecr_repository" "webhost_ecr_repo" {
  name                 = "webhostrepo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
} */