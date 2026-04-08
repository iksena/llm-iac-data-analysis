resource "aws_emrcontainers_virtual_cluster" "this" {
  region = var.region
  name   = var.name
  tags   = var.tags

  container_provider {
    id   = var.container_provider.id
    type = var.container_provider.type

    info {
      eks_info {
        namespace = var.container_provider.info.eks_info.namespace
      }
    }
  }
}