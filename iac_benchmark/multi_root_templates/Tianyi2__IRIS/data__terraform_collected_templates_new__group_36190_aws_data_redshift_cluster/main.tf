data "aws_redshift_cluster" "this" {
  region             = var.region
  cluster_identifier = var.cluster_identifier
}