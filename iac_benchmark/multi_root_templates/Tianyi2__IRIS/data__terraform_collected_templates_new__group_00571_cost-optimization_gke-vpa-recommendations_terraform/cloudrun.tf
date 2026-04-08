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


resource "google_cloud_run_v2_job" "metric_exporter" {
  name         = var.job_name
  location     = var.region
  
  template {
    task_count  = 1
    parallelism = 0
    labels      = local.resource_labels
    template {
      service_account = google_service_account.service_account.email
      timeout         = "3600s"
      containers {
        image = var.image
        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }
        env {
            name = "LOGGING_LEVEL"
            value = "INFO"
        }
        env {
            name = "BIGQUERY_DATASET"
            value = var.BIGQUERY_DATASET
        }
        env {
            name = "BIGQUERY_TABLE"
            value = var.BIGQUERY_TABLE
        }
        env {
            name = "RECOMMENDATION_WINDOW_SECONDS"
            value = var.RECOMMENDATION_WINDOW_SECONDS
        }
        env {
            name = "RECOMMENDATION_DISTANCE"
            value = var.RECOMMENDATION_DISTANCE
        }
        env {
            name = "METRIC_WINDOW"
            value = var.METRIC_WINDOW
        }
        env {
            name = "METRIC_DISTANCE"
            value = var.METRIC_DISTANCE
        }
        env {
            name = "LATEST_WINDOW_SECONDS"
            value = var.LATEST_WINDOW_SECONDS
        }
        env {
            name = "PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION"
            value = "python"
        }
        resources {
          limits = {
            memory = var.job_run_memory
            cpu = var.job_run_cpu
          }
        }
      }
    }
  }
}
