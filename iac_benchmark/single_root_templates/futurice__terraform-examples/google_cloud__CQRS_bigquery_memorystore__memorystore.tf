# ── variables.tf ────────────────────────────────────
variable "config" {
  type = any
}


# ── outputs.tf ────────────────────────────────────
output "memorystore_host" {
  value = google_redis_instance.cache.host
}


# ── memorystore.tf ────────────────────────────────────
resource "google_redis_instance" "cache" {
  name                    = "redis"
  memory_size_gb          = 1
  project                 = var.config.project
  location_id             = "${var.config.region}-c"
  tier                    = "BASIC"
  authorized_network      = var.config.network
}
