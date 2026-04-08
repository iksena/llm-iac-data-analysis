variable "gcp_project" {
  description = "GCP project and region defaults."
  type        = map(string)
  default = {
    region  = "europe-north1",
    zone    = "europe-north1-a",
    project = "tbd-dev-7ff9"
  }
}

variable "spre_styringsinfo_cloud_sql_port" {
  description = "The port exposed by the spre-styringsinfo database Cloud SQL instance."
  type        = string
  default     = "5435"
}