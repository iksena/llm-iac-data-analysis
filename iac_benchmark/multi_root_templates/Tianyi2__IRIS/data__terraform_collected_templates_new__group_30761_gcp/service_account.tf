/*
 * attendance_request_bot
 * 友人に毎週月曜日に講義の出席を依頼するボット
 */
resource "google_service_account" "attendance_request_scheduler_sa" {
  account_id   = "cloud-run-invoker-sa-a-r-s"
  display_name = "Cloud Run Invoker Service Account"
}

data "google_iam_policy" "attendance_request_scheduler_sa_invoker" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.attendance_request_scheduler_sa.email}"
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "attendance_request_scheduler_sa_policy" {
  location    = google_cloud_run_service.attendance_request_bot.location
  service     = google_cloud_run_service.attendance_request_bot.name
  policy_data = data.google_iam_policy.attendance_request_scheduler_sa_invoker.policy_data
}

/*
 * igsr5_daily
 * igsr5の日報アプリ
 */
resource "google_service_account" "igsr5_daily_sa" {
  account_id   = "cloud-run-invoker-sa-i-d"
  display_name = "Cloud Run Invoker Service Account"
}

data "google_iam_policy" "igsr5_daily_invoker" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.igsr5_daily_sa.email}",
      "allUsers"
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "igsr5_daily_sa_policy" {
  location    = google_cloud_run_service.igsr5_daily.location
  service     = google_cloud_run_service.igsr5_daily.name
  policy_data = data.google_iam_policy.igsr5_daily_invoker.policy_data
}

/*
 * github-project-automation-prototype
 * igsr5の個人向けのGitHubプロジェクト自動化ツール
 */
resource "google_service_account" "github_project_automation_prototype_sa" {
  account_id   = "cloud-run-invoker-sa-g-p-a-p"
  display_name = "Cloud Run Invoker Service Account"
}

data "google_iam_policy" "github_project_automation_prototype_invoker" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.github_project_automation_prototype_sa.email}",
      "allUsers"
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "github_project_automation_prototype_sa_policy" {
  location    = google_cloud_run_service.github_project_automation_prototype.location
  service     = google_cloud_run_service.github_project_automation_prototype.name
  policy_data = data.google_iam_policy.github_project_automation_prototype_invoker.policy_data
}
