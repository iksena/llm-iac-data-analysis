output "admin_user_name" {
    value = google_sql_user.admin_user.name
}

output "admin_user_password" {
    value = random_id.admin_user_password.hex
    sensitive = true
}
