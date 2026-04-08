output "arn" {
  description = "The target assessment ARN."
  value       = aws_inspector_assessment_target.this.arn
}