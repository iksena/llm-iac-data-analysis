I'll help you create a Terraform configuration that sets up an S3 bucket with a public access block. This configuration will:

1. Create an S3 bucket with basic settings
2. Configure a public access block for the bucket to control public access settings
3. Use AWS provider in us-east-1 region
4. Include versioning for the bucket as a best practice

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
  default     = "my-example-terraform-bucket-2024"
}

# S3 Bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Example Bucket"
    Environment = "Dev"
  }
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.example_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Public Access Block
resource "aws_s3_bucket_public_access_block" "example_bucket_public_access_block" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the bucket name
output "bucket_name" {
  value       = aws_s3_bucket.example_bucket.id
  description = "The name of the S3 bucket"
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-east-1 region
2. Defines a variable for the bucket name with a default value
3. Creates an S3 bucket with basic configuration and tags
4. Enables versioning on the bucket
5. Creates a public access block that:
   - Blocks public ACLs
   - Blocks public bucket policies
   - Ignores public ACLs
   - Restricts public bucket access
6. Outputs the bucket name for reference

The public access block ensures that the bucket remains private and cannot be accidentally made public through bucket policies or ACLs. This is a security best practice for S3 buckets.

To deploy this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

You can customize the bucket name by either changing the default value in the variables section or by providing it during deployment using a tfvars file or command line argument.