module "server_ecr_image" {
  source = "../../modules/aws-ecr-repository"

  ecr_repository_name = "monoweb/prd/dashboard"
}

data "aws_ecr_image" "dashboard" {
  repository_name = module.server_ecr_image.ecr_repository_name
  most_recent     = true
}
