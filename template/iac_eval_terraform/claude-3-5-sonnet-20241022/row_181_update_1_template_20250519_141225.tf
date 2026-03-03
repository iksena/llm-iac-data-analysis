provider "aws" {
  region = "us-east-1"
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_pipeline_role" {
  name = "sagemaker-pipeline-role"

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
  role       = aws_iam_role.sagemaker_pipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# Create SageMaker Pipeline
resource "aws_sagemaker_pipeline" "example" {
  pipeline_name = "example-pipeline"
  pipeline_display_name = "Example Pipeline"
  role_arn     = aws_iam_role.sagemaker_pipeline_role.arn

  pipeline_definition = jsonencode({
    Version = "2020-12-01"
    Parameters = [
      {
        Name = "ProcessingInstanceCount"
        Type = "Integer"
        DefaultValue = 1
      }
    ]
    Steps = [
      {
        Name = "Processing"
        Type = "Processing"
        Arguments = {
          ProcessingResources = {
            ClusterConfig = {
              InstanceCount = {
                Get = "Parameters.ProcessingInstanceCount"
              }
              InstanceType = "ml.m5.xlarge"
              VolumeSizeInGB = 30
            }
          }
          AppSpecification = {
            ImageUri = "737474898029.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"
            ContainerArguments = ["--input-data", "s3://my-bucket/input", "--output-data", "s3://my-bucket/output"]
          }
          RoleArn = aws_iam_role.sagemaker_pipeline_role.arn
        }
      }
    ]
  })

  tags = {
    Environment = "Development"
    Project     = "MLOps"
  }
}