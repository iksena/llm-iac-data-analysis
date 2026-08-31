output "canary_arns" {
  value       = { for idx, canary in aws_synthetics_canary.dynamic_canaries_with_vpc : canary.name => canary.arn }
  description = "ARNs of all canaries created"
}
