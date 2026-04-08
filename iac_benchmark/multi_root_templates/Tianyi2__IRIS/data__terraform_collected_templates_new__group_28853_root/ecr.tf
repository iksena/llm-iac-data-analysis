resource "aws_ecr_repository" "backend" {
  name                 = "chatroom-backend-tf"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
}
