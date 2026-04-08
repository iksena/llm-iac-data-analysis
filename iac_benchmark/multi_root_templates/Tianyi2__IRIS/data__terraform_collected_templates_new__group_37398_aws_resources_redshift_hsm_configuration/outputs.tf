output "region" {
  description = "Region where this resource will be managed."
  value       = aws_redshift_hsm_configuration.this.region
}

output "description" {
  description = "A text description of the HSM configuration to be created."
  value       = aws_redshift_hsm_configuration.this.description
}

output "hsm_configuration_identifier" {
  description = "The identifier to be assigned to the new Amazon Redshift HSM configuration."
  value       = aws_redshift_hsm_configuration.this.hsm_configuration_identifier
}

output "hsm_ip_address" {
  description = "The IP address that the Amazon Redshift cluster must use to access the HSM."
  value       = aws_redshift_hsm_configuration.this.hsm_ip_address
}

output "hsm_partition_name" {
  description = "The name of the partition in the HSM where the Amazon Redshift clusters will store their database encryption keys."
  value       = aws_redshift_hsm_configuration.this.hsm_partition_name
}

output "hsm_partition_password" {
  description = "The password required to access the HSM partition."
  value       = aws_redshift_hsm_configuration.this.hsm_partition_password
  sensitive   = true
}

output "hsm_server_public_certificate" {
  description = "The HSMs public certificate file. When using Cloud HSM, the file name is server.pem."
  value       = aws_redshift_hsm_configuration.this.hsm_server_public_certificate
}

output "tags" {
  description = "A map of tags to assign to the resource."
  value       = aws_redshift_hsm_configuration.this.tags
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the Hsm Client Certificate."
  value       = aws_redshift_hsm_configuration.this.arn
}


output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshift_hsm_configuration.this.tags_all
}