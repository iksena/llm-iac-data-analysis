output "arns" {
  description = "Set of ARN of the Links."
  value       = data.aws_oam_links.this.arns
}