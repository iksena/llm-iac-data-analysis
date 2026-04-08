data "aws_controltower_controls" "this" {
  region            = var.region
  target_identifier = var.target_identifier
}