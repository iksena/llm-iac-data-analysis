resource "aws_dx_connection" "this" {
  region          = var.region
  bandwidth       = var.bandwidth
  encryption_mode = var.encryption_mode
  location        = var.location
  name            = var.name
  provider_name   = var.provider_name
  request_macsec  = var.request_macsec
  skip_destroy    = var.skip_destroy
  tags            = var.tags
}