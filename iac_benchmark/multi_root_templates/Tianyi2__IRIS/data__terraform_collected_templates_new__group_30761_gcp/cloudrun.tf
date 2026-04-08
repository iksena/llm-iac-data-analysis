/*
 * attendance_request_bot
 * 友人に毎週月曜日に講義の出席を依頼するボット
 */
resource "google_cloud_run_service" "attendance_request_bot" {
  name     = "attendance-request-bot"
  location = "asia-northeast1"

  template {
    spec {
      containers {
        // NOTE: This is temporary. This will be replaced with a container image.
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  lifecycle {
    ignore_changes = [template]
  }
}

/*
 * igsr5_daily
 * igsr5の日報アプリ
 */
resource "google_cloud_run_service" "igsr5_daily" {
  name                       = "igsr5-daily"
  location                   = "asia-northeast1"
  autogenerate_revision_name = true

  template {
    spec {
      containers {
        // NOTE: This is temporary. This will be replaced with a container image.
        image = "us-docker.pkg.dev/cloudrun/container/hello"

        env {
          name  = "TZ"
          value = "Asia/Tokyo"
        }

        env {
          name  = "NODE_ENV"
          value = "production"
        }

        env {
          name = "DATABASE_URL"
          value_from {
            secret_key_ref {
              name = "igsr5-daily--database-url"
              key  = "5"
            }
          }
        }

        env {
          name = "SLACK_BOT_TOKEN"
          value_from {
            secret_key_ref {
              name = "igsr5-daily--slack-bot-token"
              key  = "2"
            }
          }
        }
        env {
          name = "SLACK_WEBHOOK_URL"
          value_from {
            secret_key_ref {
              name = "igsr5-daily--slack-webhook-url"
              key  = "1"
            }
          }
        }

        env {
          name = "SLACK_SIGNING_SECRET"
          value_from {
            secret_key_ref {
              name = "igsr5-daily--slack-signing-secret"
              key  = "2"
            }
          }
        }

        env {
          name = "SLACK_ADMIN_USER_ID"
          value_from {
            secret_key_ref {
              name = "igsr5-daily--slack-admin-user-id"
              key  = "2"
            }
          }
        }

      }
    }
  }

  lifecycle {
    ignore_changes = [template[0].spec[0].containers[0].image]
  }
}

/*
 * github-project-automation-prototype
 * igsr5の個人向けのGitHubプロジェクト自動化ツール
 */
resource "google_cloud_run_service" "github_project_automation_prototype" {
  name                       = "github-project-automation-prototype"
  location                   = "asia-northeast1"
  autogenerate_revision_name = true

  template {
    spec {
      containers {
        // NOTE: This is temporary. This will be replaced with a container image.
        image = "us-docker.pkg.dev/cloudrun/container/hello"

        env {
          name = "GH_TOKEN"
          value_from {
            secret_key_ref {
              name = "github-project-automation-prototype-gh-token"
              key  = "latest"
            }
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [template[0].spec[0].containers[0].image]
  }
}

