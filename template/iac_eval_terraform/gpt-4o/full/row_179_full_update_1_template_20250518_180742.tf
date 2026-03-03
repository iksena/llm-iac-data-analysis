The Terraform program will create an AWS SageMaker Notebook Instance using the `ml.t2.medium` instance type. This configuration will include the necessary IAM role for the SageMaker Notebook to function properly. The program will be set up to deploy in the `us-west-2` region. The IAM role will have the necessary permissions to allow SageMaker to perform its operations.

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
          "logs:CreateLogGroup",
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
}

```

</iac_template>