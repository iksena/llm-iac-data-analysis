output "dns_name" {
  value = aws_lb.bastion.dns_name
}

output "s3_bucket" {
  value = aws_s3_bucket.ssh_public_keys.id
}

output "security_group" {
  value = aws_security_group.bastion.id
}

output "zone_id" {
  value = aws_lb.bastion.zone_id
}

output "s3_vpc_endpoint_id" {
  value = aws_vpc_endpoint.s3_bucket.id
}
