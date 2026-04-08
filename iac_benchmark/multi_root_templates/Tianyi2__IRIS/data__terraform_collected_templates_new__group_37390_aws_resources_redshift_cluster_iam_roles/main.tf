resource "aws_redshift_cluster_iam_roles" "this" {
  region               = var.region
  cluster_identifier   = var.cluster_identifier
  iam_role_arns        = var.iam_role_arns
  default_iam_role_arn = var.default_iam_role_arn
}