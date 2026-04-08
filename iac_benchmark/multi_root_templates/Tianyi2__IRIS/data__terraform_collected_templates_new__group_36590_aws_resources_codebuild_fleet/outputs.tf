output "arn" {
  description = "ARN of the Fleet"
  value       = aws_codebuild_fleet.this.arn
}

output "created" {
  description = "Creation time of the fleet"
  value       = aws_codebuild_fleet.this.created
}

output "id" {
  description = "ARN of the Fleet"
  value       = aws_codebuild_fleet.this.id
}

output "last_modified" {
  description = "Last modification time of the fleet"
  value       = aws_codebuild_fleet.this.last_modified
}

output "status" {
  description = "Nested attribute containing information about the current status of the fleet"
  value       = aws_codebuild_fleet.this.status
}

output "status_context" {
  description = "Additional information about a compute fleet"
  value       = try(tolist(aws_codebuild_fleet.this.status)[0].context, null)
}

output "status_message" {
  description = "Message associated with the status of a compute fleet"
  value       = try(tolist(aws_codebuild_fleet.this.status)[0].message, null)
}

output "status_code" {
  description = "Status code of the compute fleet"
  value       = try(tolist(aws_codebuild_fleet.this.status)[0].status_code, null)
}