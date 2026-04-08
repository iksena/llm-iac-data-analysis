output "id" {
  description = "Resource ID in the format: analyzer_name/rule_name."
  value       = aws_accessanalyzer_archive_rule.this.id
}