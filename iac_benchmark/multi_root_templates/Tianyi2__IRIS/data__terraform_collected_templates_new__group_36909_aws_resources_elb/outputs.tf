output "id" {
  description = "The name of the ELB"
  value       = aws_elb.this.id
}

output "arn" {
  description = "The ARN of the ELB"
  value       = aws_elb.this.arn
}

output "name" {
  description = "The name of the ELB"
  value       = aws_elb.this.name
}

output "dns_name" {
  description = "The DNS name of the ELB"
  value       = aws_elb.this.dns_name
}

output "instances" {
  description = "The list of instances in the ELB"
  value       = aws_elb.this.instances
}

output "source_security_group" {
  description = "The name of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances. Use this for Classic or Default VPC only."
  value       = aws_elb.this.source_security_group
}

output "source_security_group_id" {
  description = "The ID of the security group that you can use as part of your inbound rules for your load balancer's back-end application instances. Only available on ELBs launched in a VPC."
  value       = aws_elb.this.source_security_group_id
}

output "zone_id" {
  description = "The canonical hosted zone ID of the ELB (to be used in a Route 53 Alias record)"
  value       = aws_elb.this.zone_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_elb.this.tags_all
}