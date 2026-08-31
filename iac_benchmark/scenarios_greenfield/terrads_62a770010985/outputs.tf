// VPC
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC id"
}

// Subnets
output "subnets_private_ids" {
  value       = aws_subnet.private.*.id
  description = "Private subnets ids"
}

output "subnets_public_ids" {
  value       = aws_subnet.public.*.id
  description = "Public subnets ids"
}

//Security Groups
output "sg_App_Forms_id" {
  value       = aws_security_group.App_Forms.id
  description = "App Core security group id"
}

output "sg_App_Trainer_id" {
  value       = aws_security_group.App_Trainer.id
  description = "App Trainer security group id"
}

output "sg_DataDB_id" {
  value       = aws_security_group.DataDB.id
  description = "DB security group id"
}

output "sg_App_Forms_ALB_id" {
  value       = aws_security_group.App_Forms_ELB.id
  description = "ALB security group id"
}

output "sg_Splunk_Instance_id" {
  value       = aws_security_group.Splunk_Instance.id
  description = "Splunk Instance security group id"
}

//R53
output "r53_zone_id" {
  value       = aws_route53_zone.zone.zone_id
  description = "DNS zone id"
}

output "r53_zone_name_servers" {
  value       = aws_route53_zone.zone.name_servers
  description = "List of name servers for DNS zone"
}

output "kms_key_id" {
  value       = aws_kms_key.key.key_id
  description = "KMS key ID"
}

output "kms_key_arn" {
  value       = aws_kms_key.key.arn
  description = "KMS key Arn"
}

output "kms_alias_id" {
  value       = "alias/${var.solution_short}-${var.env}"
  description = "KMS Alias ID"
}

output "kms_alias_arn" {
  value       = aws_kms_alias.key-alias.arn
  description = "KMS Alias Arn"
}

output "kms_alias_target_key_arn" {
  value       = aws_kms_alias.key-alias.target_key_arn
  description = "KMS Alias Target Key Arn"
}

output "Policy_UseKMS_arn" {
  value       = aws_iam_policy.kms.arn
  description = "KMS Policy Arn"
}

output "s3_access-logs_bucket_id" {
  value       = aws_s3_bucket.access-logs.id
  description = "S3 Bucket for access logs id"
}

