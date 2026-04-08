# variables.tf

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "location" {
  description =" Location  for storage bucket"
  type = string
  default = "us-central1"
}

variable "regions" {
  description = "A list of GCP regions for deploying resilient resources."
  type        = list(string)
  default     = ["us-central1", "us-east1"]
}

variable "multi_region_location" {
  description = "The multi-region location for GCS and KMS (e.g., US, EU, ASIA)."
  type        = string
  default     = "US"
}

# New variables for C2PA configuration
variable "c2pa_claim_generator" {
  description = "The name of the claim generator to be embedded in the C2PA manifest."
  type        = string
  default     = "My-Resilient-GCP-C2PA-Signer/1.0"
}

variable "c2pa_author_name" {
  description = "The author and copyright holder name for the C2PA manifest."
  type        = string
  default     = "My Organization"
}

variable "c2pa_author_org" {
  description = "The Organization (O) for the C2PA certificate (e.g., 'Acme Corp')"
  type        = string
  default     = "C2PA on GCP"
}