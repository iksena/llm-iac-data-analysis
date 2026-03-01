provider "aws" {
  region = "us-west-2"
}

# Variables
variable "connect_instance_alias" {
  description = "Alias for the Connect instance"
  type        = string
  default     = "my-connect-instance"
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

# Create Connect instance
resource "aws_connect_instance" "example" {
  identity_management_type = "SAML"
  instance_alias          = var.connect_instance_alias
  inbound_calls_enabled   = true
  outbound_calls_enabled  = true
}

# Create Lex bot association
resource "aws_connect_bot_association" "example" {
  instance_id = aws_connect_instance.example.id
  
  lex_bot {
    name       = "CustomerServiceBot"
    lex_region = "us-west-2"
  }
}

# Outputs
output "connect_instance_arn" {
  value = aws_connect_instance.example.arn
}

output "connect_instance_id" {
  value = aws_connect_instance.example.id
}