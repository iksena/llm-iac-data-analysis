output "id" {
  description = "DB Instance Identifier and IAM Role ARN separated by a comma (,)"
  value       = aws_db_instance_role_association.this.id
}