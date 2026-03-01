To create a SageMaker Pipeline using Terraform, we need to define a few key components. This includes setting up the AWS provider, creating an IAM role with the necessary permissions for SageMaker, and defining the SageMaker Pipeline resource itself. The pipeline will be a simple example, as the actual steps and configurations can vary greatly depending on the specific machine learning workflow.

Below is the Terraform configuration to create a SageMaker Pipeline:

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
          "sagemaker:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sagemaker_pipeline" "example_pipeline" {
  name = "ExamplePipeline"

  role_arn = aws_iam_role.sagemaker_execution_role.arn

  pipeline_definition = jsonencode({
    Version = "2020-12-01"
    Metadata = {
      "PipelineName" = "ExamplePipeline"
    }
    PipelineDefinition = {
      Steps = [
        {
          Name = "ExampleStep"
          Type = "Processing"
          Arguments = {
            ProcessingJobName = "example-processing-job"
            AppSpecification = {
              ImageUri = "123456789012.dkr.ecr.us-west-2.amazonaws.com/my-custom-image:latest"
            }
            ProcessingResources = {
              ClusterConfig = {
                InstanceCount = 1
                InstanceType = "ml.m5.large"
                VolumeSizeInGB = 30
              }
            }
            RoleArn = aws_iam_role.sagemaker_execution_role.arn
          }
        }
      ]
    }
  })
}
```
</iac_template>

This configuration sets up a basic SageMaker Pipeline with a single processing step. The IAM role is configured to allow SageMaker to assume it and perform necessary actions on S3 and SageMaker resources. The pipeline definition is a simple JSON structure that specifies the steps and their configurations. Adjust the `ImageUri` and other parameters as needed for your specific use case.