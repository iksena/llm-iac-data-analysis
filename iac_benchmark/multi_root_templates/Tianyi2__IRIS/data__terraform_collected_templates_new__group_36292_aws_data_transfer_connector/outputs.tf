output "access_role" {
  description = "ARN of the AWS Identity and Access Management role."
  value       = data.aws_transfer_connector.this.access_role
}

output "arn" {
  description = "ARN of the Connector."
  value       = data.aws_transfer_connector.this.arn
}

output "as2_config" {
  description = "Structure containing the parameters for an AS2 connector object."
  value       = data.aws_transfer_connector.this.as2_config
}

output "as2_config_basic_auth_secret_id" {
  description = "Basic authentication for AS2 connector API."
  value       = try(data.aws_transfer_connector.this.as2_config[0].basic_auth_secret_id, null)
}

output "as2_config_compression" {
  description = "Specifies whether AS2 file is compressed. Will be ZLIB or DISABLED."
  value       = try(data.aws_transfer_connector.this.as2_config[0].compression, null)
}

output "as2_config_encryption_algorithm" {
  description = "Algorithm used to encrypt file. Will be AES128_CBC or AES192_CBC or AES256_CBC or DES_EDE3_CBC or NONE."
  value       = try(data.aws_transfer_connector.this.as2_config[0].encryption_algorithm, null)
}

output "as2_config_local_profile_id" {
  description = "Unique identifier for AS2 local profile."
  value       = try(data.aws_transfer_connector.this.as2_config[0].local_profile_id, null)
}

output "as2_config_mdn_response" {
  description = "Used for outbound requests to tell if response is asynchronous or not. Will be either SYNC or NONE."
  value       = try(data.aws_transfer_connector.this.as2_config[0].mdn_response, null)
}

output "as2_config_mdn_signing_algorithm" {
  description = "Signing algorithm for MDN response. Will be SHA256 or SHA384 or SHA512 or SHA1 or NONE or DEFAULT."
  value       = try(data.aws_transfer_connector.this.as2_config[0].mdn_signing_algorithm, null)
}

output "as2_config_message_subject" {
  description = "Subject HTTP header attribute in outbound AS2 messages to the connector."
  value       = try(data.aws_transfer_connector.this.as2_config[0].message_subject, null)
}

output "as2_config_partner_profile_id" {
  description = "Unique identifier used by connector for partner profile."
  value       = try(data.aws_transfer_connector.this.as2_config[0].partner_profile_id, null)
}

# output "as2_config_signing_algorithm" {
#   description = "Algorithm used for signing AS2 messages sent with the connector."
#   value       = try(data.aws_transfer_connector.this.as2_config[0].signing_algorithm, null)
# }

output "logging_role" {
  description = "ARN of the IAM role that allows a connector to turn on CloudWatch logging for Amazon S3 events."
  value       = data.aws_transfer_connector.this.logging_role
}

output "security_policy_name" {
  description = "Name of security policy."
  value       = data.aws_transfer_connector.this.security_policy_name
}

output "service_managed_egress_ip_addresses" {
  description = "List of egress IP addresses."
  value       = data.aws_transfer_connector.this.service_managed_egress_ip_addresses
}

output "sftp_config" {
  description = "Object containing SFTP configuration attributes."
  value       = data.aws_transfer_connector.this.sftp_config
}

output "sftp_config_trusted_host_keys" {
  description = "List of the public portions of the host keys that are used to identify the servers the connector is connected to."
  value       = try(data.aws_transfer_connector.this.sftp_config[0].trusted_host_keys, null)
}

output "sftp_config_user_secret_id" {
  description = "Identifier for the secret in AWS Secrets Manager that contains the SFTP user's private key, and/or password."
  value       = try(data.aws_transfer_connector.this.sftp_config[0].user_secret_id, null)
}

output "tags" {
  description = "Object containing tag attributes."
  value       = data.aws_transfer_connector.this.tags
}

output "url" {
  description = "URL of the partner's AS2 or SFTP endpoint."
  value       = data.aws_transfer_connector.this.url
}