I'll help you create a Terraform configuration for an AWS Elastic Beanstalk application with version lifecycle management. This configuration will:

1. Create an Elastic Beanstalk application
2. Set up application version lifecycle rules to retain versions for 5 days
3. Configure the AWS provider
4. Include necessary variables with default values

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "application_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
  default     = "my-eb-application"
}

variable "description" {
  description = "Description of the Elastic Beanstalk application"
  type        = string
  default     = "My Elastic Beanstalk Application"
}

# Create Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = var.application_name
  description = var.description

  appversion_lifecycle {
    service_role          = aws_iam_role.eb_service_role.arn
    max_count            = 5  # Maximum number of versions to keep
    delete_source_from_s3 = true
    max_age_in_days      = 5  # Retain versions for 5 days
  }
}

# Create IAM role for Elastic Beanstalk
resource "aws_iam_role" "eb_service_role" {
  name = "eb-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eb_enhanced_health" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
  role       = aws_iam_role.eb_service_role.name
}

resource "aws_iam_role_policy_attachment" "eb_service" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
  role       = aws_iam_role.eb_service_role.name
}

# Output the application name
output "elastic_beanstalk_application_name" {
  value = aws_elastic_beanstalk_application.eb_app.name
}
</iac_template>

This Terraform configuration creates:

1. An AWS Elastic Beanstalk application with version lifecycle management
2. An IAM role with necessary permissions for Elastic Beanstalk
3. Application version lifecycle rules that:
   - Retain versions for 5 days
   - Keep a maximum of 5 versions
   - Delete source bundles from S3 when versions are deleted
4. Appropriate IAM role policies for Elastic Beanstalk service operations

The configuration includes all necessary components and can be deployed as-is. It uses the us-west-2 region by default, but you can modify the provider configuration to use a different region if needed. The application name and description can be customized through variables, which have default values provided.