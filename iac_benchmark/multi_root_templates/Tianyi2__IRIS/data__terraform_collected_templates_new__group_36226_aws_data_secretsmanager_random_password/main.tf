data "aws_secretsmanager_random_password" "this" {
  region                     = var.region
  exclude_characters         = var.exclude_characters
  exclude_lowercase          = var.exclude_lowercase
  exclude_numbers            = var.exclude_numbers
  exclude_punctuation        = var.exclude_punctuation
  exclude_uppercase          = var.exclude_uppercase
  include_space              = var.include_space
  password_length            = var.password_length
  require_each_included_type = var.require_each_included_type
}