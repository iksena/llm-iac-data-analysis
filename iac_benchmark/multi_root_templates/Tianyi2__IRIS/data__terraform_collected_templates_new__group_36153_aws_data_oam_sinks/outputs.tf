output "arns" {
  description = "Set of ARN of the Sinks."
  value       = data.aws_oam_sinks.this.arns
}