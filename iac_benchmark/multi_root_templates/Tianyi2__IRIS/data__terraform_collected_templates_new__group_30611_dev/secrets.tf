data "google_secret_manager_secret_version" "spre_styringsinfo_datastream_user_secret" {
  secret = "spre_styringsinfo_datastream_user_secret"
}

locals {
  spre_styringsinfo_db_credentials = jsondecode(
    data.google_secret_manager_secret_version.spre_styringsinfo_datastream_user_secret.secret_data
  )
}

// Epost-adresse vi gir tilgang til å lese data
data "google_secret_manager_secret_version" "team_sak_epost_secret" {
  secret = "team_sak_epost_secret"
}

locals {
  team_sak_epost = data.google_secret_manager_secret_version.team_sak_epost_secret.secret_data
}
