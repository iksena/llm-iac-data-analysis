I'll help you create a Terraform configuration to set up a SageMaker Human Task UI resource in AWS. This configuration will:

1. Create an S3 bucket to store the HTML template
2. Upload the HTML template file to the S3 bucket
3. Create a SageMaker Human Task UI resource using the template

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Random string for unique bucket naming
resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

# Create S3 bucket for template storage
resource "aws_s3_bucket" "template_bucket" {
  bucket = "sagemaker-human-task-ui-${random_string.random.result}"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "template_bucket_versioning" {
  bucket = aws_s3_bucket.template_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "template_bucket_public_access_block" {
  bucket = aws_s3_bucket.template_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload template file to S3
resource "aws_s3_object" "template_file" {
  bucket  = aws_s3_bucket.template_bucket.id
  key     = "sagemaker-human-task-ui-template.html"
  content = <<EOF
<h1>
    TEST
</h1>
EOF
  content_type = "text/html"
}

# Create IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "sagemaker-human-task-ui-role"

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
  role       = aws_iam_role.sagemaker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# Create SageMaker Human Task UI
resource "aws_sagemaker_human_task_ui" "example" {
  human_task_ui_name = "example-human-task-ui"

  ui_template {
    content = aws_s3_object.template_file.content
  }
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-west-2 region
2. Creates a random string to ensure unique S3 bucket naming
3. Creates an S3 bucket with versioning enabled and public access blocked
4. Uploads the HTML template file to the S3 bucket
5. Creates an IAM role with necessary permissions for SageMaker
6. Creates the SageMaker Human Task UI resource using the template

The configuration includes all necessary resources and dependencies, and provides appropriate IAM roles and permissions. The HTML template is directly embedded in the configuration as specified in your requirements.

You can deploy this configuration using standard Terraform commands:
```
terraform init
terraform plan
terraform apply
```