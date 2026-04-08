output "assignment_id" {
  description = "Assignment ID"
  value       = aws_quicksight_iam_policy_assignment.this.assignment_id
}

output "id" {
  description = "A comma-delimited string joining AWS account ID, namespace, and assignment name"
  value       = aws_quicksight_iam_policy_assignment.this.id
}