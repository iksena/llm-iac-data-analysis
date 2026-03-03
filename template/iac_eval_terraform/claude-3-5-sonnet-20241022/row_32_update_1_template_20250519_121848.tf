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