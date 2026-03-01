provider "aws" {
  region = "us-west-2"
}

# Variables
variable "space_name" {
  description = "Name of the SageMaker Space"
  type        = string
  default     = "demo-space"
}

variable "domain_id" {
  description = "ID of the SageMaker Domain"
  type        = string
  default     = "d-xxxxxxxxxxxx" # Replace with your domain ID
}

# IAM Role for SageMaker
resource "aws_iam_role" "sagemaker_space_role" {
  name = "sagemaker-space-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AmazonSageMakerFullAccess policy to the role
resource "aws_iam_role_policy_attachment" "sagemaker_space_policy" {
  role       = aws_iam_role.sagemaker_space_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# Create SageMaker Space
resource "aws_sagemaker_space" "example" {
  domain_id  = var.domain_id
  space_name = var.space_name

  space_settings {
    jupyter_server_app_settings {
      default_resource_spec {
        instance_type = "system"
      }
    }
    kernel_gateway_app_settings {
      default_resource_spec {
        instance_type = "ml.t3.medium"
      }
    }
  }

  tags = {
    Name = "demo-sagemaker-space"
    Environment = "development"
  }
}