output "arn" {
  value = aws_sns_topic.this.arn
}

output "kms_key_arn" {
  value = aws_kms_key.sns.arn
}
