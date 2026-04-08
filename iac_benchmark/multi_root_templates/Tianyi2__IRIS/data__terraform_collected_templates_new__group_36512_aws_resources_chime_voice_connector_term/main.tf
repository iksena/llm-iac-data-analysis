resource "aws_chime_voice_connector_termination" "this" {
  region               = var.region
  voice_connector_id   = var.voice_connector_id
  cidr_allow_list      = var.cidr_allow_list
  calling_regions      = var.calling_regions
  disabled             = var.disabled
  default_phone_number = var.default_phone_number
  cps_limit            = var.cps_limit
}