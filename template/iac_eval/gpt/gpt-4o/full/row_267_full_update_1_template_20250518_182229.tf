The Terraform program will create an Amazon S3 bucket in the AWS cloud. The bucket will be configured with default settings and will be located in the "us-east-1" region. The bucket name will be specified as "example-bucket-terraform" and will be unique to ensure successful creation. The program will include the necessary provider configuration for AWS.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "example-bucket-terraform"
  acl    = "private"

  tags = {
    Name        = "ExampleBucket"
    Environment = "Dev"
  }
}
```
</iac_template>