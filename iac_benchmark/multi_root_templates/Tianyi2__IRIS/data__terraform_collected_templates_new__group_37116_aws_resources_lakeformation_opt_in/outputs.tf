output "region" {
  description = "Region where this resource is managed."
  value       = aws_lakeformation_opt_in.this.region
}

output "principal" {
  description = "Lake Formation principal."
  value       = aws_lakeformation_opt_in.this.principal
}

output "resource_data" {
  description = "Structure for the resource."
  value       = aws_lakeformation_opt_in.this.resource_data
}

output "condition" {
  description = "Lake Formation condition, which applies to permissions and opt-ins that contain an expression."
  value       = aws_lakeformation_opt_in.this.condition
}

output "last_modified" {
  description = "Last modified date and time of the record."
  value       = aws_lakeformation_opt_in.this.last_modified
}

