resource "aws_ecs_cluster" "dit_paas_cluster" {
  name               = "dit-paas-${var.cluster_name}-cluster"
  tags = {
    Name    = "dit-paas-${var.cluster_name}-cluster"
    Cluster = var.cluster_name
  }
}
