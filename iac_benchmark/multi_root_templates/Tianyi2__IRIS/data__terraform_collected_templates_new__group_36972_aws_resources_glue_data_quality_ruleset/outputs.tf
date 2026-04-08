output "arn" {
  description = "ARN of the Glue Data Quality Ruleset."
  value       = aws_glue_data_quality_ruleset.this.arn
}

output "created_on" {
  description = "The time and date that this data quality ruleset was created."
  value       = aws_glue_data_quality_ruleset.this.created_on
}

output "last_modified_on" {
  description = "The time and date that this data quality ruleset was created."
  value       = aws_glue_data_quality_ruleset.this.last_modified_on
}

output "recommendation_run_id" {
  description = "When a ruleset was created from a recommendation run, this run ID is generated to link the two together."
  value       = aws_glue_data_quality_ruleset.this.recommendation_run_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_glue_data_quality_ruleset.this.tags_all
}