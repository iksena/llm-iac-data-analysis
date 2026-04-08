output "id" {
  description = "Unique identifier for the preferences resource. Since preferences are for the entire account, this will be the 12-digit account id."
  value       = aws_costoptimizationhub_preferences.this.id
}