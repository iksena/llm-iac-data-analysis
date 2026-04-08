resource "aws_ecrpublic_repository_policy" "this" {
  region          = var.region
  repository_name = var.repository_name
  policy          = var.policy
}