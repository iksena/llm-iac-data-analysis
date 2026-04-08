# Create a managed DB instance
resource "google_sql_database_instance" "db" {

  name             = var.name
  database_version = "POSTGRES_14"
  region           = var.region

  deletion_protection = false

  settings {
    tier = var.tier

    ip_configuration {
      ipv4_enabled  = true
      private_network = var.private_network_id
      require_ssl = true
    }

    # TODO: once SQL Auth Proxy is shown to work, consider making sure that no networks are authorized
    #  (so connectivity only is supported via SQL Auth Proxy)

    disk_type = "PD_SSD"
    disk_size = var.disk_size_gb

    # Enable IAM authentication
    # Reference: https://cloud.google.com/sql/docs/postgres/authentication#instance_configuration_for
    # Reference: https://binx.io/2021/05/19/how-to-connect-to-a-cloudsql-with-iam-authentication/
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
}
