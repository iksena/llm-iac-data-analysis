output "customer_router_config" {
  description = "Instructions for configuring your router"
  value       = data.aws_dx_router_configuration.this.customer_router_config
}

output "router" {
  description = "Block of the router type details"
  value       = data.aws_dx_router_configuration.this.router
}

output "router_platform" {
  description = "Router platform"
  value       = data.aws_dx_router_configuration.this.router[0].platform
}

output "router_type_identifier" {
  description = "Router type identifier"
  value       = data.aws_dx_router_configuration.this.router[0].router_type_identifier
}

output "router_software" {
  description = "Router operating system"
  value       = data.aws_dx_router_configuration.this.router[0].software
}

output "router_vendor" {
  description = "Router vendor"
  value       = data.aws_dx_router_configuration.this.router[0].vendor
}

output "router_xslt_template_name" {
  description = "Router XSLT Template Name"
  value       = data.aws_dx_router_configuration.this.router[0].xslt_template_name
}

