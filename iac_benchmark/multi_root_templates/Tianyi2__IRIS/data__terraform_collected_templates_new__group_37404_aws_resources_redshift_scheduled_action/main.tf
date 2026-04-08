resource "aws_redshift_scheduled_action" "this" {
  name        = var.name
  description = var.description
  enable      = var.enable
  start_time  = var.start_time
  end_time    = var.end_time
  schedule    = var.schedule
  iam_role    = var.iam_role

  target_action {
    dynamic "pause_cluster" {
      for_each = var.pause_cluster != null ? [var.pause_cluster] : []
      content {
        cluster_identifier = pause_cluster.value.cluster_identifier
      }
    }

    dynamic "resize_cluster" {
      for_each = var.resize_cluster != null ? [var.resize_cluster] : []
      content {
        cluster_identifier = resize_cluster.value.cluster_identifier
        classic            = resize_cluster.value.classic
        cluster_type       = resize_cluster.value.cluster_type
        node_type          = resize_cluster.value.node_type
        number_of_nodes    = resize_cluster.value.number_of_nodes
      }
    }

    dynamic "resume_cluster" {
      for_each = var.resume_cluster != null ? [var.resume_cluster] : []
      content {
        cluster_identifier = resume_cluster.value.cluster_identifier
      }
    }
  }
}