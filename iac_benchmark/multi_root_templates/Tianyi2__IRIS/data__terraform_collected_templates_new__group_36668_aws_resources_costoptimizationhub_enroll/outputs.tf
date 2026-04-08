output "status" {
  description = "Status of enrollment. When the resource is present in Terraform, its status will always be 'Active'."
  value       = aws_costoptimizationhub_enrollment_status.this.status
}