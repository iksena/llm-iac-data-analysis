output "arn" {
  description = "ARN of the link."
  value       = aws_oam_link.this.arn
}

output "id" {
  description = "ARN of the link. Use arn instead."
  value       = aws_oam_link.this.id
}

output "label" {
  description = "Label that is assigned to this link."
  value       = aws_oam_link.this.label
}

output "link_id" {
  description = "ID string that AWS generated as part of the link ARN."
  value       = aws_oam_link.this.link_id
}

output "sink_arn" {
  description = "ARN of the sink that is used for this link."
  value       = aws_oam_link.this.sink_arn
}