resource "vultr_instance" "gw" {
  plan   = "vc2-1c-1gb"
  region = "ams"
  label  = "gw"
}
