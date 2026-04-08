output "arn" {
  description = "ARN for the branch."
  value       = aws_amplify_branch.this.arn
}

output "associated_resources" {
  description = "A list of custom resources that are linked to this branch."
  value       = aws_amplify_branch.this.associated_resources
}

output "custom_domains" {
  description = "Custom domains for the branch."
  value       = aws_amplify_branch.this.custom_domains
}

output "destination_branch" {
  description = "Destination branch if the branch is a pull request branch."
  value       = aws_amplify_branch.this.destination_branch
}

output "source_branch" {
  description = "Source branch if the branch is a pull request branch."
  value       = aws_amplify_branch.this.source_branch
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_amplify_branch.this.tags_all
}