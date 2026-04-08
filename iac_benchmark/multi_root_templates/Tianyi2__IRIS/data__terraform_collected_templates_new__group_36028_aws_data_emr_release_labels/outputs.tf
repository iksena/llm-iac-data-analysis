output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_emr_release_labels.this.region
}

output "filters" {
  description = "Filters applied to the request."
  value       = var.filters
}

output "release_labels" {
  description = "Returned release labels."
  value       = data.aws_emr_release_labels.this.release_labels
}