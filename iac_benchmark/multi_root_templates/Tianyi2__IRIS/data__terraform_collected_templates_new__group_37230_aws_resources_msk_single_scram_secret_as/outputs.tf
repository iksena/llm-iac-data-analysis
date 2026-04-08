output "id" {
  description = "The ID of the MSK SCRAM Secret Association (cluster_arn,secret_arn)"
  value       = aws_msk_single_scram_secret_association.this.id
}

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the MSK cluster"
  value       = aws_msk_single_scram_secret_association.this.cluster_arn
}

output "secret_arn" {
  description = "AWS Secrets Manager secret ARN"
  value       = aws_msk_single_scram_secret_association.this.secret_arn
}