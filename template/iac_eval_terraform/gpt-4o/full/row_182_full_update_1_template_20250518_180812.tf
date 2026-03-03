The Terraform program will create an AWS SageMaker Human Task UI resource. This resource is used to define a user interface template for human workers to complete tasks in a SageMaker Ground Truth labeling job. The HTML content for the UI template will be provided directly within the Terraform configuration. The program will include the necessary IAM roles and policies to allow SageMaker to access the resources it needs. The configuration will be set up to deploy in the `us-west-2` region.

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
  name   = "SageMakerExecutionPolicy"
  role   = aws_iam_role.sagemaker_execution_role.id
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
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_human_task_ui" "example" {
  human_task_ui_name = "example-human-task-ui"

  ui_template {
    content = <<EOF
<h1>
    TEST
</h1>
EOF
  }
}
```
</iac_template>