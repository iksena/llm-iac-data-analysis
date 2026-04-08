output "aws_region" {
  description = "AWS region"
  value       = data.aws_region.this.name
}

output "talos_iam_user" {
  description = "Talos IAM user credentials"
  sensitive   = true
  value = {
    access_key_id     = aws_iam_access_key.talos.id
    secret_access_key = aws_iam_access_key.talos.secret
  }
}

output "coredns_iam_user" {
  description = "CoreDNS IAM user credentials"
  sensitive   = true
  value = {
    access_key_id     = aws_iam_access_key.coredns.id
    secret_access_key = aws_iam_access_key.coredns.secret
  }
}

output "route_53_zone_id" {
  description = "AWS Route 53 hosted zone id"
  value       = aws_route53_zone.main.zone_id
}
