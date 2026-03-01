provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "notebook_name" {
  description = "Name of the SageMaker Notebook instance"
  default     = "terraform-sagemaker-notebook"
}

variable "instance_type" {
  description = "Instance type for the notebook"
  default     = "ml.t2.medium"
}

# IAM Role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-notebook-role"

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

# Attach AWSServiceRoleForAmazonSageMaker policy to the role
resource "aws_iam_role_policy_attachment" "sagemaker_policy" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSageMakerFullAccess"
}

# Create SageMaker Notebook Instance
resource "aws_sagemaker_notebook_instance" "notebook" {
  name                    = var.notebook_name
  role_arn               = aws_iam_role.sagemaker_role.arn
  instance_type          = var.instance_type
  default_code_repository = "https://github.com/hashicorp/terraform-provider-aws.git"

  tags = {
    Name = "terraform-sagemaker-notebook"
    Environment = "development"
  }
}

# Output the notebook instance ARN
output "notebook_instance_arn" {
  value = aws_sagemaker_notebook_instance.notebook.arn
}

# Output the notebook instance URL
output "notebook_instance_url" {
  value = aws_sagemaker_notebook_instance.notebook.url
}