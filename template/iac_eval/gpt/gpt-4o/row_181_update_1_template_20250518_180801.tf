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