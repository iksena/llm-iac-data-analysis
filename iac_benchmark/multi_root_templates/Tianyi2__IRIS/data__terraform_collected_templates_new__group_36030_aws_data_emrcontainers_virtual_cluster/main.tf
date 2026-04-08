data "aws_emrcontainers_virtual_cluster" "this" {
  region             = var.region
  virtual_cluster_id = var.virtual_cluster_id
}