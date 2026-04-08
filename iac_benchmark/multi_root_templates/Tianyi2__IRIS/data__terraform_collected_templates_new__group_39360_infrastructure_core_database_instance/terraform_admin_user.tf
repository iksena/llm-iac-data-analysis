# The admin account will be granted a password in the form of a long hexadecimal string
resource "random_id" "admin_user_password" {
  byte_length = 16
}

# Create a built-in SQL account; this will automatically be given the cloudsuperuser role
# This will be used by Terraform later when configuring the Postgres instance
resource "google_sql_user" "admin_user" {
  depends_on = [ google_sql_database_instance.db ]
  name     = "terraform-admin"
  password = random_id.admin_user_password.hex
  instance = var.name
  type     = "BUILT_IN"
}
