# IAM Policy Bindings
resource "google_project_iam_member" "service_account_iam" {
  for_each = toset(local.iam_roles)
  project  = local.gcp_project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.service_account.email}"
  depends_on = [ google_project_service.apis , google_service_account.service_account ]
}


# # Grant full project admin access to user
# resource "google_project_iam_member" "user_owner" {
#   project = local.gcp_project_id
#   role    = "roles/owner"
#   member  = "user:ddruk2018@gmail.com"
#   depends_on = [ google_project_service.apis ]
# }