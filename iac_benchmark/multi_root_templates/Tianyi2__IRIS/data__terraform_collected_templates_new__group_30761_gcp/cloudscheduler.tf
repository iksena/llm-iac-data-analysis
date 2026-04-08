/*
 * attendance_request_bot
 * 友人に毎週月曜日に講義の出席を依頼するボット
 */

/*
 * igsr5_daily
 * igsr5の日報アプリ
 *
 * 毎日18時にSlackで日報作成を促す
 */
resource "google_cloud_scheduler_job" "igsr5_daily" {
  name             = "igsr5-daily"
  schedule         = "0 19 * * *"
  time_zone        = "Asia/Tokyo"
  attempt_deadline = "600s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = format("%s%s", google_cloud_run_service.igsr5_daily.status[0].url, "/prompt_daily_report")

    oidc_token {
      audience              = google_cloud_run_service.attendance_request_bot.status[0].url
      service_account_email = google_service_account.attendance_request_scheduler_sa.email
    }
  }
}

/*
 * igsr5の個人向けのGitHubプロジェクト自動化ツール
 *
 * 3分毎にGitHub Project Automationの実行を促す
 */
resource "google_cloud_scheduler_job" "github_project_automation_prototype_issues" {
  name             = "github-project-automation-prototype-issues"
  schedule         = "*/10 9-19 * * 1-5"
  time_zone        = "Asia/Tokyo"
  attempt_deadline = "600s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    # 大体 5 分かかる
    uri = format("%s%s", google_cloud_run_service.github_project_automation_prototype.status[0].url, "/all")

    oidc_token {
      audience              = google_cloud_run_service.github_project_automation_prototype.status[0].url
      service_account_email = google_service_account.github_project_automation_prototype_sa.email
    }
  }
}
