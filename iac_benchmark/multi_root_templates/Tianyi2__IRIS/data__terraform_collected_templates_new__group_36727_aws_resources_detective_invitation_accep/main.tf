resource "aws_detective_invitation_accepter" "this" {
  region    = var.region
  graph_arn = var.graph_arn
}