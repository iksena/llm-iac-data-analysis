To create a SageMaker Domain resource using Terraform, we need to set up the necessary AWS infrastructure that includes a SageMaker Domain. This involves defining the SageMaker Domain resource, specifying the authentication mode, and configuring the default user settings. We will also need to create an IAM role that SageMaker can assume to perform necessary actions. The configuration will be set up in the `us-west-2` region.

Here is the Terraform HCL configuration for creating a SageMaker Domain:

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

resource "aws_iam_role_policy" "sagemaker_execution_policy" {
  name = "SageMakerExecutionPolicy"
  role = aws_iam_role.sagemaker_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_domain" "example" {
  domain_name           = "example-sagemaker-domain"
  auth_mode             = "IAM"
  default_user_settings {
    execution_role = aws_iam_role.sagemaker_execution_role.arn
  }
}
```
</iac_template>

This configuration sets up a SageMaker Domain with IAM authentication mode. It creates an IAM role with the necessary permissions for SageMaker to interact with other AWS services like S3, ECR, CloudWatch, and CloudWatch Logs. The domain is named "example-sagemaker-domain" and is configured to use the created IAM role for execution.