resource "random_id" "id" {
  byte_length = 3
}

data "google_compute_image" "base_image" {
  family  = "ubuntu-2104"
  project = "ubuntu-os-cloud"
}
