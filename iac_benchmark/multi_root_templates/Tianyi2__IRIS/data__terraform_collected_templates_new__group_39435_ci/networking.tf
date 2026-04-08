module "networking" {
  source = "../modules//networking-new"

  name = local.repo

  providers = {
    aws.no-default-tags = aws.no-default-tags
  }
}