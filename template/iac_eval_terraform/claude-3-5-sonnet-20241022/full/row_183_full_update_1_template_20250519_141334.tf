I'll help you create a Terraform configuration to set up a SageMaker endpoint configuration for a SageMaker model. This configuration will:

1. Create an IAM role for SageMaker execution
2. Create a SageMaker model
3. Create an endpoint configuration
4. Create an endpoint to deploy the model

The configuration includes all necessary permissions and assumes you have a model artifact stored in S3. I'll provide default values for demonstration purposes.

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "model_name" {
  description = "Name of the SageMaker model"
  default     = "demo-model"
}

variable "model_artifact_url" {
  description = "S3 path to the model artifact"
  default     = "s3://sagemaker-demo-bucket/model.tar.gz"
}

variable "instance_type" {
  description = "Instance type for the endpoint"
  default     = "ml.t2.medium"
}

# IAM Role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-execution-role"

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

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# Create SageMaker Model
resource "aws_sagemaker_model" "model" {
  name               = var.model_name
  execution_role_arn = aws_iam_role.sagemaker_role.arn

  primary_container {
    image = "683313688378.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"
    model_data_url = var.model_artifact_url
  }
}

# Create Endpoint Configuration
resource "aws_sagemaker_endpoint_configuration" "endpoint_config" {
  name = "${var.model_name}-config"

  production_variants {
    variant_name           = "default"
    model_name            = aws_sagemaker_model.model.name
    instance_type         = var.instance_type
    initial_instance_count = 1
  }
}

# Create Endpoint
resource "aws_sagemaker_endpoint" "endpoint" {
  name                 = "${var.model_name}-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.endpoint_config.name
}

# Output
output "endpoint_name" {
  value = aws_sagemaker_endpoint.endpoint.name
}
</iac_template>

This Terraform configuration creates:

1. An IAM role with the necessary permissions for SageMaker execution
2. A SageMaker model using a scikit-learn container (you can modify the container image as needed)
3. An endpoint configuration that specifies how to deploy the model
4. An actual endpoint that deploys the model for inference

To use this configuration:

1. Make sure you have valid AWS credentials configured
2. Update the `model_artifact_url` variable to point to your actual model artifact in S3
3. Adjust the `instance_type` if you need a different instance size
4. Modify the container image in the `aws_sagemaker_model` resource if you're using a different framework

The configuration uses default values for demonstration, but you can override these by:
- Passing variables when running Terraform
- Creating a terraform.tfvars file
- Modifying the default values in the variables block

Note: Make sure your AWS account has access to the specified container image and S3 bucket containing the model artifact.