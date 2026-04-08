data "google_iam_policy" "igsr5_daily_cloud_run" {
  binding {
    role = "roles/admin"
    members = [
      "serviceAccount:823570656707-compute@developer.gserviceaccount.com",
    ]
  }

}

data "google_iam_policy" "github_project_automation_prototype_cloud_run" {
  binding {
    role = "roles/admin"
    members = [
      "serviceAccount:823570656707-compute@developer.gserviceaccount.com",
    ]
  }

}

