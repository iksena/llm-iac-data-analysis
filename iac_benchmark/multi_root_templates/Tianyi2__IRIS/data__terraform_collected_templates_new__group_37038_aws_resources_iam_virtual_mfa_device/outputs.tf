output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the virtual mfa device."
  value       = aws_iam_virtual_mfa_device.this.arn
}

output "base_32_string_seed" {
  description = "The base32 seed defined as specified in RFC3548. The base_32_string_seed is base64-encoded."
  value       = aws_iam_virtual_mfa_device.this.base_32_string_seed
  sensitive   = true
}

output "enable_date" {
  description = "The date and time when the virtual MFA device was enabled."
  value       = aws_iam_virtual_mfa_device.this.enable_date
}

output "qr_code_png" {
  description = "A QR code PNG image that encodes otpauth://totp/$virtualMFADeviceName@$AccountName?secret=$Base32String where $virtualMFADeviceName is one of the create call arguments."
  value       = aws_iam_virtual_mfa_device.this.qr_code_png
  sensitive   = true
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iam_virtual_mfa_device.this.tags_all
}

output "user_name" {
  description = "The associated IAM User name if the virtual MFA device is enabled."
  value       = aws_iam_virtual_mfa_device.this.user_name
}