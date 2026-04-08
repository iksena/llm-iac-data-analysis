output "portfolio_id" {
  description = "Portfolio identifier"
  value       = aws_servicecatalog_portfolio_share.this.portfolio_id
}

output "principal_id" {
  description = "Identifier of the principal with whom you will share the portfolio"
  value       = aws_servicecatalog_portfolio_share.this.principal_id
}

output "type" {
  description = "Type of portfolio share"
  value       = aws_servicecatalog_portfolio_share.this.type
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_servicecatalog_portfolio_share.this.region
}

output "accept_language" {
  description = "Language code"
  value       = aws_servicecatalog_portfolio_share.this.accept_language
}

output "share_principals" {
  description = "Whether Principal sharing is enabled when creating the portfolio share"
  value       = aws_servicecatalog_portfolio_share.this.share_principals
}

output "share_tag_options" {
  description = "Whether sharing of aws_servicecatalog_tag_option resources is enabled when creating the portfolio share"
  value       = aws_servicecatalog_portfolio_share.this.share_tag_options
}

output "wait_for_acceptance" {
  description = "Whether to wait for the share to be accepted"
  value       = aws_servicecatalog_portfolio_share.this.wait_for_acceptance
}

output "accepted" {
  description = "Whether the shared portfolio is imported by the recipient account. If the recipient is organizational, the share is automatically imported, and the field is always set to true"
  value       = aws_servicecatalog_portfolio_share.this.accepted
}