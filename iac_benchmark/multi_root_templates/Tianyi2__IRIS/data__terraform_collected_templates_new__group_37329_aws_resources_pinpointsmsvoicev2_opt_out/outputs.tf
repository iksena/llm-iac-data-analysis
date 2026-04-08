output "arn" {
  description = "ARN of the opt-out list."
  value       = aws_pinpointsmsvoicev2_opt_out_list.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_pinpointsmsvoicev2_opt_out_list.this.tags_all
}