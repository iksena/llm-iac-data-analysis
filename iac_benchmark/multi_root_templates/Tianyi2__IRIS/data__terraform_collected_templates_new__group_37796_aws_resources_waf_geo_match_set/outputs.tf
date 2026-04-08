output "id" {
  description = "The ID of the WAF GeoMatchSet"
  value       = aws_waf_geo_match_set.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN)"
  value       = aws_waf_geo_match_set.this.arn
}