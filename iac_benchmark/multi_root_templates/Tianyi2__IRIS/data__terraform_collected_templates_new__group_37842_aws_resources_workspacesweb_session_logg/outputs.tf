output "associated_portal_arns" {
  description = "List of ARNs of the web portals associated with the session logger"
  value       = aws_workspacesweb_session_logger.this.associated_portal_arns
}

output "session_logger_arn" {
  description = "ARN of the session logger"
  value       = aws_workspacesweb_session_logger.this.session_logger_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_workspacesweb_session_logger.this.tags_all
}