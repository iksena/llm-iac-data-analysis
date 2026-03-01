Description:
This Terraform configuration deploys an AWS S3 bucket named "my_bucket". In addition, it creates an S3 bucket policy that denies all S3 actions from a specific IP address, defined by the variable "denied_ip". The policy is built using the jsonencode function which converts the HCL map into a valid JSON policy. The policy includes a version "2012-10-17", an identifier "DenyIPPolicy", and a statement that denies access for any action on both the bucket and its objects when requests come from the specified IP address. A default variable value for the denied IP address is provided ("203.0.113.0/32"), and the AWS provider is configured to use the "us-east-1" region.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my_bucket"
}

variable "denied_ip" {
  description = "IP address to deny access from (in CIDR notation)"
  type        = string
  default     = "203.0.113.0/32"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version   = "2012-10-17"
    Id        = "DenyIPPolicy"
    Statement = [
      {
        Sid       = "DenyIPAddress"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = var.denied_ip
          }
        }
      }
    ]
  })
}
</iac_template>