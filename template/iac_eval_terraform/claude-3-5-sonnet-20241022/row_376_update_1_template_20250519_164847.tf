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