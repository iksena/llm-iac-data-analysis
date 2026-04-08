# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


resource "google_cloud_scheduler_job" "job" {
  name             = var.schedule_name
  description      = var.schedule_description
  schedule         = var.schedule
  time_zone        = var.schedule_timezone
  region           = var.region
  attempt_deadline = "320s"
  
  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${var.job_name}:run"
    body        = base64encode("")

    oauth_token {
      service_account_email = google_service_account.service_account.email
      
    }
  }
}
