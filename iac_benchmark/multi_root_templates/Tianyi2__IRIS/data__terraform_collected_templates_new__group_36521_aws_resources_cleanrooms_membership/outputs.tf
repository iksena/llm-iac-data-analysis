output "arn" {
  description = "The ARN of the membership."
  value       = aws_cleanrooms_membership.this.arn
}

output "collaboration_arn" {
  description = "The ARN of the joined collaboration."
  value       = aws_cleanrooms_membership.this.collaboration_arn
}

output "collaboration_creator_account_id" {
  description = "The account ID of the collaboration's creator."
  value       = aws_cleanrooms_membership.this.collaboration_creator_account_id
}

output "collaboration_creator_display_name" {
  description = "The display name of the collaboration's creator."
  value       = aws_cleanrooms_membership.this.collaboration_creator_display_name
}

output "collaboration_id" {
  description = "The ID of the joined collaboration."
  value       = aws_cleanrooms_membership.this.collaboration_id
}

output "collaboration_name" {
  description = "The name of the joined collaboration."
  value       = aws_cleanrooms_membership.this.collaboration_name
}

output "create_time" {
  description = "The date and time the membership was created."
  value       = aws_cleanrooms_membership.this.create_time
}

output "id" {
  description = "The ID of the membership."
  value       = aws_cleanrooms_membership.this.id
}

output "member_abilities" {
  description = "The list of abilities for the invited member."
  value       = aws_cleanrooms_membership.this.member_abilities
}

output "payment_configuration_query_compute_is_responsible" {
  description = "Indicates whether the collaboration member has accepted to pay for query compute costs."
  value       = aws_cleanrooms_membership.this.payment_configuration[0].query_compute[0].is_responsible
}

output "status" {
  description = "The status of the membership."
  value       = aws_cleanrooms_membership.this.status
}

output "update_time" {
  description = "The date and time the membership was last updated."
  value       = aws_cleanrooms_membership.this.update_time
}