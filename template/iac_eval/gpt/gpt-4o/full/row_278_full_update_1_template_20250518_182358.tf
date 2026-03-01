To address the business need of storing and uploading a PDF file to AWS, we will create an S3 bucket to store the file. We will also use the AWS provider to manage the infrastructure. The Terraform configuration will include the creation of an S3 bucket and the upload of the specified PDF file to this bucket. We will ensure that the bucket is publicly accessible for reading the file, and we will use the AWS IAM role to manage permissions.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "pdf_bucket" {
  bucket = "my-pdf-storage-bucket-123456"
  acl    = "public-read"

  tags = {
    Name        = "PDF Storage Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "pdf_upload" {
  bucket = aws_s3_bucket.pdf_bucket.bucket
  key    = "test.pdf"
  source = "assets/test.pdf"
  acl    = "public-read"
}

output "pdf_url" {
  value = "https://${aws_s3_bucket.pdf_bucket.bucket}.s3.amazonaws.com/${aws_s3_bucket_object.pdf_upload.key}"
}
```
</iac_template>

This Terraform configuration will create an S3 bucket named "my-pdf-storage-bucket-123456" and upload the PDF file located at "assets/test.pdf" to this bucket. The file will be publicly accessible, and the output will provide the URL to access the uploaded PDF. Make sure to replace the bucket name with a unique name as S3 bucket names must be globally unique.