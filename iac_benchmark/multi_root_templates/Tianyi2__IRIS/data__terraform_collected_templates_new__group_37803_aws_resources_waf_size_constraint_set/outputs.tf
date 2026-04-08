output "id" {
  description = "ID of the WAF Size Constraint Set"
  value       = aws_waf_size_constraint_set.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN)"
  value       = aws_waf_size_constraint_set.this.arn
}

output "name" {
  description = "Name or description of the Size Constraint Set"
  value       = aws_waf_size_constraint_set.this.name
}