output "arn" {
  description = "The Amazon Resource Name (ARN) identifying the repository association"
  value       = aws_codegurureviewer_repository_association.this.arn
}

output "association_id" {
  description = "The ID of the repository association"
  value       = aws_codegurureviewer_repository_association.this.association_id
}

output "connection_arn" {
  description = "The Amazon Resource Name (ARN) of an AWS CodeStar Connections connection"
  value       = aws_codegurureviewer_repository_association.this.connection_arn
}

output "id" {
  description = "The Amazon Resource Name (ARN) identifying the repository association"
  value       = aws_codegurureviewer_repository_association.this.id
}

output "name" {
  description = "The name of the repository"
  value       = aws_codegurureviewer_repository_association.this.name
}

output "owner" {
  description = "The owner of the repository"
  value       = aws_codegurureviewer_repository_association.this.owner
}

output "provider_type" {
  description = "The provider type of the repository association"
  value       = aws_codegurureviewer_repository_association.this.provider_type
}

output "state" {
  description = "The state of the repository association"
  value       = aws_codegurureviewer_repository_association.this.state
}

output "state_reason" {
  description = "A description of why the repository association is in the current state"
  value       = aws_codegurureviewer_repository_association.this.state_reason
}