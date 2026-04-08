output "id" {
  description = "The ID of the QLDB Stream."
  value       = aws_qldb_stream.this.id
}

output "arn" {
  description = "The ARN of the QLDB Stream."
  value       = aws_qldb_stream.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_qldb_stream.this.tags_all
}