# https://www.terraform.io/docs/configuration/outputs.html

output "region" {
  value       = var.region
  description = "The AWS Region for deployment."
}

output "environment" {
  value       = var.environment
  description = "The name of environment for deployment."
}

output "availability_zones" {
  value       = join(",", slice(data.aws_availability_zones.available.names, 0, local.az_len))
  description = "A comma-separated string of availability zones."
}

output "availability_zones_list" {
  value       = slice(data.aws_availability_zones.available.names, 0, local.az_len)
  description = "The list of availability zones."
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC."
}

output "vpc_cidr" {
  value       = aws_vpc.main.cidr_block
  description = "The CIDR block of the VPC."
}

output "private_subnet_ids" {
  value       = join(",", aws_subnet.private.*.id)
  description = "A comma-separated string of private subnet IDs."
}

output "private_subnets_list" {
  description = "A list of private subnets."
  value = [for subnet in aws_subnet.private: {
    id                = subnet.id
    availability_zone = subnet.availability_zone
    cidr              = subnet.cidr_block
  }]
}

output "public_subnet_ids" {
  value       = join(",", aws_subnet.public.*.id)
  description = "A comma-separated string of public subnet IDs."
}

output "public_subnets_list" {
  description = "A list of public subnets."
  value = [for subnet in aws_subnet.public: {
    id                = subnet.id
    availability_zone = subnet.availability_zone
    cidr              = subnet.cidr_block
  }]
}

output "kops_subdomain" {
  value       = local.subdomain
  description = "The name of DNS zone for kops."
}

output "kops_s3_bucket" {
  value       = aws_s3_bucket.kops.id
  description = "The name of S3 bucket for kops state."
}

output "kops_encrypted_secret" {
  value       = aws_iam_access_key.kops.encrypted_secret
  description = "The encrypted AWS Secret Access Key for kops user."
}

output "resource_tags" {
  value       = join(",", [ for k, v in merge(local.common_tags, local.region_tag) : format("%s=%s", k, v) ])
  description = "A comma-separated string of AWS tags."
}
