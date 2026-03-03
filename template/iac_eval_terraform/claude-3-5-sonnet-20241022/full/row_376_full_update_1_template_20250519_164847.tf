I'll help you create a Terraform configuration to provision an AWS Lightsail certificate. This configuration will:

1. Set up the AWS provider
2. Create a Lightsail certificate for a domain
3. Include necessary variables with default values

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1" # Lightsail certificates are global but provider needs a region
}

# Variables
variable "domain_name" {
  description = "Domain name for the certificate"
  type        = string
  default     = "example.com"
}

variable "subject_alternative_names" {
  description = "Additional domain names for the certificate"
  type        = list(string)
  default     = ["*.example.com"]
}

# Lightsail Certificate
resource "aws_lightsail_certificate" "cert" {
  name                      = "certificate-${var.domain_name}"
  domain_name              = var.domain_name
  subject_alternative_names = var.subject_alternative_names

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Output the certificate ARN
output "certificate_arn" {
  value       = aws_lightsail_certificate.cert.arn
  description = "The ARN of the Lightsail certificate"
}
</iac_template>

This Terraform configuration creates an AWS Lightsail certificate with the following components:

1. AWS Provider configuration set to us-east-1 region
2. Variables for domain name and subject alternative names with default values
3. A Lightsail certificate resource with:
   - Dynamic name based on domain
   - Domain name configuration
   - Subject alternative names support
   - Tags for better resource management
4. Output for the certificate ARN

To use this configuration:
1. Replace the default domain_name value with your actual domain
2. Adjust the subject_alternative_names as needed
3. Make sure you have AWS credentials configured
4. Run terraform init and terraform apply

Note: After creating the certificate, you'll need to validate domain ownership through DNS validation or email validation as per AWS Lightsail's requirements.