output "arn" {
  description = "ARN of the listener"
  value       = data.aws_lb_listener.this.arn
}

output "load_balancer_arn" {
  description = "ARN of the load balancer"
  value       = data.aws_lb_listener.this.load_balancer_arn
}

output "port" {
  description = "Port of the listener"
  value       = data.aws_lb_listener.this.port
}

output "protocol" {
  description = "Protocol of the listener"
  value       = data.aws_lb_listener.this.protocol
}

output "ssl_policy" {
  description = "SSL policy of the listener"
  value       = data.aws_lb_listener.this.ssl_policy
}

output "certificate_arn" {
  description = "ARN of the SSL certificate"
  value       = data.aws_lb_listener.this.certificate_arn
}

output "default_action" {
  description = "Configuration block for default actions"
  value       = data.aws_lb_listener.this.default_action
}

output "alpn_policy" {
  description = "Name of the Application-Layer Protocol Negotiation (ALPN) policy"
  value       = data.aws_lb_listener.this.alpn_policy
}

output "mutual_authentication" {
  description = "Configuration block for mutual authentication"
  value       = data.aws_lb_listener.this.mutual_authentication
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = data.aws_lb_listener.this.tags
}