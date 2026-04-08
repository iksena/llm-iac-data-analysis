variable "project_id" {
  description = "The GCP Project ID where the backend resources will be created."
  type        = string
}

variable "location" {
  description = "The location for the GCS bucket (e.g., US, EU)."
  type        = string
  default     = "US"
}
