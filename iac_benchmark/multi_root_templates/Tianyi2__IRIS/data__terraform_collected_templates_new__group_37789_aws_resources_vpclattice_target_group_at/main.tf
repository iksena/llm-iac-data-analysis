resource "aws_vpclattice_target_group_attachment" "this" {
  region                  = var.region
  target_group_identifier = var.target_group_identifier

  target {
    id   = var.target_id
    port = var.target_port
  }
}