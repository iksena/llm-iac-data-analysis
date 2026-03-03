provider "aws" {
  region = "us-west-2"
}

# Variables
variable "connect_instance_alias" {
  description = "Alias for the Connect instance"
  type        = string
  default     = "my-connect-instance"
}

variable "saml_metadata_url" {
  description = "URL of the SAML metadata"
  type        = string
  default     = "https://portal.sso.us-west-2.amazonaws.com/saml/metadata/123456"
}

# IAM role for Connect instance
resource "aws_iam_role" "connect_service_role" {
  name = "connect-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "connect.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the Connect service role
resource "aws_iam_role_policy_attachment" "connect_service_policy" {
  role       = aws_iam_role.connect_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonConnectServiceRole"
}

# Create Connect instance with SAML
resource "aws_connect_instance" "example" {
  identity_management_type = "SAML"
  instance_alias          = var.connect_instance_alias
  inbound_calls_enabled   = true
  outbound_calls_enabled  = true

  directory_config {
    type = "SAML"
  }

  instance_attributes = {
    "samlMetadataUrl" = var.saml_metadata_url
  }
}

# Create Lex bot association
resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  lex_bot {
    lex_region = "us-west-2"
    name       = "CustomerServiceBot"
  }
}

# Output the Connect instance ARN
output "connect_instance_arn" {
  value = aws_connect_instance.example.arn
}

# Output the Connect instance ID
output "connect_instance_id" {
  value = aws_connect_instance.example.id
}