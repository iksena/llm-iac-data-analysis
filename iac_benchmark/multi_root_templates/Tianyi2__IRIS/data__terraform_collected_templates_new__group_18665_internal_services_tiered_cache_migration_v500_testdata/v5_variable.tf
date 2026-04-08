variable "zone_id" {
  type    = string
  default = "%[2]s"
}

resource "cloudflare_tiered_cache" "%[1]s" {
  zone_id = var.zone_id
  value   = "on"
}
