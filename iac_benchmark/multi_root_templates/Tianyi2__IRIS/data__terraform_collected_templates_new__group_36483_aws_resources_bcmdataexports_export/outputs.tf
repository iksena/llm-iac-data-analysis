output "arn" {
  description = "Amazon Resource Name (ARN) for this export"
  value       = aws_bcmdataexports_export.this.arn
}

output "export_arn" {
  description = "Amazon Resource Name (ARN) for this export"
  value       = aws_bcmdataexports_export.this.export[0].export_arn
}