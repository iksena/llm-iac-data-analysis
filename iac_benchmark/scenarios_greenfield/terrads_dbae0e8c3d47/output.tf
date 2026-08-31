output "policy_arn" {
    value = aws_iam_policy_attachment.this[0].policy_arn
}
