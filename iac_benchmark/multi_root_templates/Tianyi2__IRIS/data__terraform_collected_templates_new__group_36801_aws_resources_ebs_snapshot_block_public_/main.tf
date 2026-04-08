resource "aws_ebs_snapshot_block_public_access" "this" {
  region = var.region
  state  = var.state
}