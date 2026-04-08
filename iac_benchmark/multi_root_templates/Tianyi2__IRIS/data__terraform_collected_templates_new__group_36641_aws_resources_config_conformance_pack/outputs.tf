output "arn" {
  description = "Amazon Resource Name (ARN) of the conformance pack."
  value       = aws_config_conformance_pack.this.arn
}

output "name" {
  description = "The name of the conformance pack."
  value       = aws_config_conformance_pack.this.name
}

output "region" {
  description = "Region where the conformance pack is managed."
  value       = aws_config_conformance_pack.this.region
}

output "delivery_s3_bucket" {
  description = "Amazon S3 bucket where AWS Config stores conformance pack templates."
  value       = aws_config_conformance_pack.this.delivery_s3_bucket
}

output "delivery_s3_key_prefix" {
  description = "The prefix for the Amazon S3 bucket."
  value       = aws_config_conformance_pack.this.delivery_s3_key_prefix
}

output "input_parameters" {
  description = "Set of input parameters passed to the conformance pack template."
  value       = aws_config_conformance_pack.this.input_parameter
}

output "template_body" {
  description = "The conformance pack template body."
  value       = aws_config_conformance_pack.this.template_body
}

output "template_s3_uri" {
  description = "Location of the template body file in Amazon S3."
  value       = aws_config_conformance_pack.this.template_s3_uri
}