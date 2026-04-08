data "doppler_secrets" "grades" {
  project = "grades"
  config  = "prd"

  provider = doppler
}
