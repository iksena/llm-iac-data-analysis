resource "aws_transfer_profile" "this" {
  region          = var.region
  as2_id          = var.as2_id
  certificate_ids = var.certificate_ids
  profile_type    = var.profile_type
  tags            = var.tags
}