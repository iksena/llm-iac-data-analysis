data "aws_batch_scheduling_policy" "this" {
  arn    = var.arn
  region = var.region
}