resource "aws_ecr_repository" "main" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    ModuleBy = "OVO Tech Production Engineering"
  }
}
