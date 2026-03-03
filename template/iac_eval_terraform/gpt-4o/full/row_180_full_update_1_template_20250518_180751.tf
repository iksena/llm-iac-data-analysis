To create an AWS SageMaker Notebook instance using Terraform, we will define a configuration that includes the necessary AWS provider setup, an IAM role with the required permissions for SageMaker, and the SageMaker Notebook instance itself. The configuration will specify the instance type, the IAM role, and any other necessary parameters to ensure the notebook is properly configured and deployable.

Here is the Terraform HCL configuration:

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

resource "aws_sagemaker_notebook_instance" "example" {
  name                 = "example-notebook-instance"
  instance_type        = "ml.t2.medium"
  role_arn             = aws_iam_role.sagemaker_execution_role.arn
  lifecycle_config_name = "example-lifecycle-config"

  tags = {
    Name = "ExampleSageMakerNotebook"
  }
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "example" {
  name = "example-lifecycle-config"

  on_create = <<EOF
#!/bin/bash
set -e
# Add any initialization commands here
EOF

  on_start = <<EOF
#!/bin/bash
set -e
# Add any start-up commands here
EOF
}
```
</iac_template>

This configuration sets up an AWS SageMaker Notebook instance with a specified instance type and an IAM role that allows the notebook to interact with S3 and CloudWatch. The lifecycle configuration allows for custom scripts to be run on creation and start-up of the notebook instance.