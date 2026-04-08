output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_secretsmanager_random_password.this.region
}

output "exclude_characters" {
  description = "String of the characters that you don't want in the password."
  value       = data.aws_secretsmanager_random_password.this.exclude_characters
}

output "exclude_lowercase" {
  description = "Specifies whether to exclude lowercase letters from the password."
  value       = data.aws_secretsmanager_random_password.this.exclude_lowercase
}

output "exclude_numbers" {
  description = "Specifies whether to exclude numbers from the password."
  value       = data.aws_secretsmanager_random_password.this.exclude_numbers
}

output "exclude_punctuation" {
  description = "Specifies whether to exclude punctuation characters from the password."
  value       = data.aws_secretsmanager_random_password.this.exclude_punctuation
}

output "exclude_uppercase" {
  description = "Specifies whether to exclude uppercase letters from the password."
  value       = data.aws_secretsmanager_random_password.this.exclude_uppercase
}

output "include_space" {
  description = "Specifies whether to include the space character."
  value       = data.aws_secretsmanager_random_password.this.include_space
}

output "password_length" {
  description = "Length of the password."
  value       = data.aws_secretsmanager_random_password.this.password_length
}

output "require_each_included_type" {
  description = "Specifies whether to include at least one upper and lowercase letter, one number, and one punctuation."
  value       = data.aws_secretsmanager_random_password.this.require_each_included_type
}

output "random_password" {
  description = "Random password."
  value       = data.aws_secretsmanager_random_password.this.random_password
  sensitive   = true
}