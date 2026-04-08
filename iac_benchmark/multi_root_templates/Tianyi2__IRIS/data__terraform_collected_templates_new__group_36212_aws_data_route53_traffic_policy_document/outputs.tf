output "json" {
  description = "Standard JSON policy document rendered based on the arguments above"
  value       = data.aws_route53_traffic_policy_document.this.json
}

output "record_type" {
  description = "DNS type of all of the resource record sets that Amazon Route 53 will create based on this traffic policy"
  value       = data.aws_route53_traffic_policy_document.this.record_type
}

output "start_endpoint" {
  description = "An endpoint to be as the starting point for the traffic policy"
  value       = data.aws_route53_traffic_policy_document.this.start_endpoint
}

output "start_rule" {
  description = "A rule to be as the starting point for the traffic policy"
  value       = data.aws_route53_traffic_policy_document.this.start_rule
}

output "version" {
  description = "Version of the traffic policy format"
  value       = data.aws_route53_traffic_policy_document.this.version
}

output "endpoints" {
  description = "Configuration block for the definitions of the endpoints that you want to use in this traffic policy"
  value       = data.aws_route53_traffic_policy_document.this.endpoint
}

output "rules" {
  description = "Configuration block for definitions of the rules that you want to use in this traffic policy"
  value       = data.aws_route53_traffic_policy_document.this.rule
}