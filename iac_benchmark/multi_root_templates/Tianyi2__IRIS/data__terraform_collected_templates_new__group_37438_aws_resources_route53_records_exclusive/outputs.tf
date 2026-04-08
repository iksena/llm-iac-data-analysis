output "zone_id" {
  description = "The ID of the hosted zone containing the resource record sets."
  value       = aws_route53_records_exclusive.this.zone_id
}

