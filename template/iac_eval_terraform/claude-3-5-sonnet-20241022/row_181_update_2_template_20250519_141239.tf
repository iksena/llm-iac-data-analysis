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
  pipeline_name         = "example-pipeline"
  pipeline_description  = "Example SageMaker Pipeline"
  role_arn             = aws_iam_role.sagemaker_pipeline_role.arn

  pipeline_definition = jsonencode({
    Version = "2020-12-01"
    Parameters = [
      {
        Name = "InputDataUrl",
        Type = "String",
        DefaultValue = "s3://my-bucket/input"
      }
    ],
    Steps = [
      {
        Name = "ProcessingStep",
        Type = "Processing",
        Arguments = {
          ProcessingInputs = [
            {
              InputName = "input-1",
              S3Input = {
                S3Uri = "s3://my-bucket/input",
                LocalPath = "/opt/ml/processing/input",
                S3DataType = "S3Prefix",
                S3InputMode = "File"
              }
            }
          ],
          ProcessingOutputConfig = {
            Outputs = [
              {
                OutputName = "output-1",
                S3Output = {
                  S3Uri = "s3://my-bucket/output",
                  LocalPath = "/opt/ml/processing/output",
                  S3UploadMode = "EndOfJob"
                }
              }
            ]
          },
          ProcessingResources = {
            ClusterConfig = {
              InstanceCount = 1,
              InstanceType = "ml.m5.xlarge",
              VolumeSizeInGB = 30
            }
          },
          AppSpecification = {
            ImageUri = "737474898029.dkr.ecr.us-east-1.amazonaws.com/sagemaker-scikit-learn:0.23-1-cpu-py3"
          }
        }
      }
    ]
  })

  tags = {
    Environment = "Development"
    Project     = "MLOps"
  }
}