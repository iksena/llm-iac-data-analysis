output "id" {
  description = "The Amazon Resource Name (ARN) of the accelerator"
  value       = aws_globalaccelerator_accelerator.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the accelerator"
  value       = aws_globalaccelerator_accelerator.this.arn
}

output "dns_name" {
  description = "The DNS name of the accelerator"
  value       = aws_globalaccelerator_accelerator.this.dns_name
}

output "dual_stack_dns_name" {
  description = "The Domain Name System (DNS) name that Global Accelerator creates that points to a dual-stack accelerator's four static IP addresses"
  value       = aws_globalaccelerator_accelerator.this.dual_stack_dns_name
}

output "hosted_zone_id" {
  description = "The Global Accelerator Route 53 zone ID that can be used to route an Alias Resource Record Set to the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.this.hosted_zone_id
}

output "ip_sets" {
  description = "IP address set associated with the accelerator"
  value       = aws_globalaccelerator_accelerator.this.ip_sets
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_globalaccelerator_accelerator.this.tags_all
}