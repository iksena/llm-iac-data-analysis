I'll help you create a Terraform configuration that sets up an Amazon Connect instance with SAML authentication and associates a Lex bot with it. This configuration will:

1. Create an Amazon Connect instance with SAML authentication
2. Create a Lex bot association with the Connect instance
3. Set up necessary IAM roles and policies
4. Configure required variables with default values

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. Variables for the Connect instance alias and SAML metadata URL with default values
3. An IAM role and policy attachment for the Connect service
4. An Amazon Connect instance configured with SAML authentication
5. A Lex bot association with the Connect instance
6. Outputs for the Connect instance ARN and ID

To use this configuration:

1. Make sure you have valid AWS credentials configured
2. Update the `saml_metadata_url` variable with your actual SAML metadata URL
3. Update the Lex bot name in the `aws_connect_bot_association` resource if needed
4. You can customize the region in the provider block if needed
5. You can modify the Connect instance settings (like instance_alias) by updating the variables

The configuration includes all necessary components and should be deployable as-is, assuming you have the appropriate AWS permissions and a valid SAML provider configured.