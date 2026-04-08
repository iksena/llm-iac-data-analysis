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

# Project variables
variable "project_id" {
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "us-central1"
}

variable "resource_labels" {
  type        = map(string)
  description = "Resource labels"
  default     = {}
}

# Cloud scheduler variables
variable "schedule_name"{
    default = "recommendation-schedule"
}

variable "schedule_description"{
default = "Cloud Run Job schedule to trigger workload recommendations job"
}

variable "schedule" {
  description = "The schedule on which the Cloud Scheduler job should run"
  default     = "0 23 * * *"
}

variable "schedule_timezone" {
  description = "The timezone for the Cloud Scheduler job"
  default     = "America/New_York"
}

# Cloud run job variables
variable "image" {
  description = "The Docker image to deploy to Cloud Run Job"
}

variable "job_name" {
  description = "The name of the Cloud Scheduler job"
  default     = "workload-recommendations"
}

variable "job_run_memory" {
  description = "The amount of memory to allocate to the Cloud Run service"
  default     = "1Gi"
}

variable "job_run_cpu" {
  description = "The amount of CPU to allocate to the Cloud Run service"
  default     = "1"
}

variable "RECOMMENDATION_WINDOW_SECONDS" {
  description = "The timeframe for VPA recommendations. Defaults to 1209600 seconds, or 14 days. "
  default     = 1209600
}

variable "RECOMMENDATION_DISTANCE" {
  description = "The interval at which data points are returned. The default is 1 day (86400 seconds)"
  default     = 86400
}

variable "LATEST_WINDOW_SECONDS" {
  description = "The timeframe for obtaining the most recent requested and limit resource values. Defaults to 600 seconds, or 10 minutes"
  default     = 600
}

variable "METRIC_WINDOW" {
  description = "Establishes the timeframe for GKE usage and utilization metrics. Defaults to 259200 seconds, or 3 days"
  default     = 259200
}

variable "METRIC_DISTANCE" {
  description = "The interval at which data points are returned. Defaults to 600 seconds, or 10 minutes."
  default     = 600
}

# BigQuery variables
variable "BIGQUERY_DATASET" {
  description = "The name of the BigQuery dataset"
  default     = "gke_metric_dataset"
}

variable "BIGQUERY_TABLE" {
  description = "The name of the BigQuery table"
  default     = "gke_metrics"
}

variable "bigquery_recommendations_view" {
  description = "The name of the BigQuery container recommendation view"
  default     = "container_recommendations"
}
locals {
  resource_labels = merge(var.resource_labels, {
    deployed_by = "cloudbuild"
    solution    = "goog-ab-gke-workload-recs"
    terraform   = "true"
  })
}
