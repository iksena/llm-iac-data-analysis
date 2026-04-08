resource "aws_ecr_repository" "tomcat_project" {
  name                 = "tomcat_project"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
