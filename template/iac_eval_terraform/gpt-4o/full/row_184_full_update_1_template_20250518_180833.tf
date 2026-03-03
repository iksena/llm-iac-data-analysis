To create a SageMaker endpoint using Terraform, we need to define several AWS resources. These include a SageMaker model, an endpoint configuration, and the endpoint itself. We'll also need an IAM role that SageMaker can assume to access other AWS services. The configuration will be set up in the `us-west-2` region. 

The Terraform program will include:
1. An AWS provider configuration.
2. An IAM role with a policy that allows SageMaker to perform necessary actions.
3. A SageMaker model resource.
4. A SageMaker endpoint configuration resource.
5. A SageMaker endpoint resource.

Here is the complete Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "sagemaker_execution_role" {
  name = "SageMakerExecutionRole"
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
  name = "SageMakerPolicy"
  role = aws_iam_role.sagemaker_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_model" "example" {
  name = "example-model"
  execution_role_arn = aws_iam_role.sagemaker_execution_role.arn

  primary_container {
    image = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-custom-image:latest"
    model_data_url = "s3://my-bucket/model.tar.gz"
  }
}

resource "aws_sagemaker_endpoint_configuration" "example" {
  name = "example-endpoint-config"

  production_variants {
    variant_name = "AllTraffic"
    model_name = aws_sagemaker_model.example.name
    initial_instance_count = 1
    instance_type = "ml.m5.large"
  }
}

resource "aws_sagemaker_endpoint" "example" {
  name = "example-endpoint"
  endpoint_config_name = aws_sagemaker_endpoint_configuration.example.name
}
```
</iac_template>

This configuration sets up a SageMaker endpoint using a custom Docker image stored in Amazon ECR and model data stored in an S3 bucket. The IAM role allows SageMaker to access S3 and CloudWatch services. Adjust the `image` and `model_data_url` to point to your actual resources.