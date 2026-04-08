output "analysis_id" {
  description = "Identifier for the analysis."
  value       = data.aws_quicksight_analysis.this.analysis_id
}

output "aws_account_id" {
  description = "AWS account ID."
  value       = data.aws_quicksight_analysis.this.aws_account_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_quicksight_analysis.this.region
}