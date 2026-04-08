output "arn" {
  description = "ARN (Amazon Resource Name) of the AWS Chime SDK Voice Sip Media Application"
  value       = aws_chimesdkvoice_sip_media_application.this.arn
}

output "id" {
  description = "The SIP media application ID."
  value       = aws_chimesdkvoice_sip_media_application.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_chimesdkvoice_sip_media_application.this.tags_all
}