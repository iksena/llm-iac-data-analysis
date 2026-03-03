To create a SageMaker endpoint configuration for a SageMaker model using Terraform, we need to define a few resources. First, we will define the AWS provider and specify a region. Then, we will create an IAM role that SageMaker can assume to access necessary resources. After that, we will define a SageMaker model resource, which will be used in the SageMaker endpoint configuration. Finally, we will create the SageMaker endpoint configuration itself, which references the SageMaker model.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "sagemaker_execution_role" {
  name = "sagemaker_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "sagemaker_policy" {
  name = "sagemaker_policy"
  role = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_model" "example_model" {
  name          = "example-model"
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn

  primary_container {
    image = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-custom-image:latest"
    model_data_url = "s3://my-bucket/model.tar.gz"
  }
}

resource "aws_sagemaker_endpoint_configuration" "example_endpoint_config" {
  name = "example-endpoint-config"

  production_variants {
    variant_name = "AllTraffic"
    model_name   = aws_sagemaker_model.example_model.name
    initial_instance_count = 1
    instance_type = "ml.m5.large"
  }
}
```
</iac_template>

This configuration sets up an IAM role for SageMaker, defines a SageMaker model with a specified container image and model data, and creates an endpoint configuration that uses this model. The endpoint configuration specifies the instance type and initial instance count for the deployment.