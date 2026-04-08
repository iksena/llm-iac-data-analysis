resource "aws_batch_scheduling_policy" "this" {
  name = var.name

  dynamic "fair_share_policy" {
    for_each = var.fair_share_policy != null ? [var.fair_share_policy] : []
    content {
      compute_reservation = fair_share_policy.value.compute_reservation
      share_decay_seconds = fair_share_policy.value.share_decay_seconds

      dynamic "share_distribution" {
        for_each = fair_share_policy.value.share_distribution != null ? fair_share_policy.value.share_distribution : []
        content {
          share_identifier = share_distribution.value.share_identifier
          weight_factor    = share_distribution.value.weight_factor
        }
      }
    }
  }

  tags = var.tags
}