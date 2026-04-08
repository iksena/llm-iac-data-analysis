module "server_ecr_image" {
  source = "../../modules/aws-ecr-repository"

  ecr_repository_name = "vengeful-vineyard/prod/server"
}

data "aws_ecr_image" "server" {
  repository_name = "vengeful-vineyard/prod/server"
  most_recent     = true
}
