I'll help you create a Terraform configuration that sets up an S3 bucket with versioning enabled. This configuration will:

1. Create an S3 bucket with a unique name
2. Enable versioning on the bucket to maintain multiple versions of objects
3. Include proper AWS provider configuration
4. Add basic bucket configurations like tags

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-versioned-bucket-example-2024"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "production"
}

# S3 Bucket Resource
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Managed_by  = "terraform"
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Output the bucket name and versioning status
output "bucket_name" {
  value = aws_s3_bucket.example_bucket.id
}

output "versioning_status" {
  value = aws_s3_bucket_versioning.versioning_example.versioning_configuration[0].status
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider in the us-east-1 region
2. Defines variables for the bucket name and environment with default values
3. Creates an S3 bucket with tags
4. Enables versioning on the bucket using the aws_s3_bucket_versioning resource
5. Provides outputs for the bucket name and versioning status

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the changes: `terraform plan`
3. Apply the configuration: `terraform apply`

The bucket name uses a default value, but you can override it by:
- Passing it as a command-line variable: `terraform apply -var="bucket_name=your-bucket-name"`
- Setting it in a terraform.tfvars file
- Setting it through an environment variable: `export TF_VAR_bucket_name=your-bucket-name`

Note: S3 bucket names must be globally unique across all AWS accounts, so you might need to modify the default bucket name if it's already taken.