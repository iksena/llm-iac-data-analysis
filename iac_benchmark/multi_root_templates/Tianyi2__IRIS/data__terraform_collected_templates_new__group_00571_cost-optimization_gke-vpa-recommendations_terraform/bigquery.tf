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

resource "google_bigquery_dataset" "dataset" {
  dataset_id  = var.BIGQUERY_DATASET
  description = "GKE container recommendations dataset"
  location    = var.region
  labels      = var.resource_labels
}

resource "google_bigquery_table" "gke_metrics" {
  dataset_id          = google_bigquery_dataset.dataset.dataset_id
  table_id            = var.BIGQUERY_TABLE
  description         = "GKE system and scale metrics"
  deletion_protection = false
  
  time_partitioning {
    type = "DAY"
  }

  labels = local.resource_labels

  schema = file("../scripts/sql/bigquery_schema.json")
 
}

resource "google_bigquery_table" "workload_recommendation_view" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = var.bigquery_recommendations_view
  deletion_protection=false
  view {
    query = templatefile("../scripts/sql/container_recommendations.sql", { project_id = var.project_id, table_dataset = var.BIGQUERY_DATASET, table_id = var.BIGQUERY_TABLE })
    use_legacy_sql = false
  }
  labels = local.resource_labels
  depends_on = [google_bigquery_table.gke_metrics]
}
