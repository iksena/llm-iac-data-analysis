data "aws_eks_cluster_versions" "this" {
  region         = var.region
  cluster_type   = var.cluster_type
  default_only   = var.default_only
  include_all    = var.include_all
  version_status = var.version_status
}