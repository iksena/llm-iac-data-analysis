I'll help you create a Terraform configuration that sets up an S3 bucket with payment configuration. This configuration will:

1. Create an S3 bucket with basic settings
2. Create a payment configuration (RequestPayment) for the S3 bucket that enables requester pays functionality
3. Use AWS provider with a specific region
4. Include necessary variables with default values

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
  default     = "my-example-payment-bucket"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "production"
}

# S3 Bucket
resource "aws_s3_bucket" "payment_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# S3 Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "payment_bucket_ownership" {
  bucket = aws_s3_bucket.payment_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 Bucket Request Payment Configuration
resource "aws_s3_bucket_request_payment_configuration" "payment_config" {
  bucket = aws_s3_bucket.payment_bucket.id
  payer  = "Requester"
}

# Output the bucket name
output "bucket_name" {
  value       = aws_s3_bucket.payment_bucket.id
  description = "The name of the created S3 bucket"
}

# Output the bucket payment configuration
output "payment_configuration" {
  value       = aws_s3_bucket_request_payment_configuration.payment_config.payer
  description = "The payment configuration of the bucket"
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider for the us-east-1 region
2. Defines variables for bucket name and environment with default values
3. Creates an S3 bucket with basic configuration
4. Sets up bucket ownership controls to ensure proper functioning of the payment configuration
5. Configures the bucket with "Requester Pays" functionality
6. Provides outputs for the bucket name and payment configuration

The configuration enables "Requester Pays" on the S3 bucket, which means that the requester will pay for requests and data transfer costs associated with their requests to the bucket, while the bucket owner will pay for storage costs.

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

You can customize the bucket name and environment by either:
- Modifying the default values in the variables
- Providing values when running Terraform
- Using a tfvars file

The configuration is complete and deployable as-is with the default values provided.