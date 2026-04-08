output "json" {
  description = "Standard JSON policy document rendered based on the arguments above."
  value       = data.aws_iam_policy_document.this.json
}

output "minified_json" {
  description = "Minified JSON policy document rendered based on the arguments above."
  value       = data.aws_iam_policy_document.this.minified_json
}