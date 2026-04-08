resource "aws_ivs_playback_key_pair" "this" {
  public_key = var.public_key
  region     = var.region
  name       = var.name
  tags       = var.tags

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}