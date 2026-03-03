The Terraform program will define an AWS Elastic Beanstalk application environment specifically configured to run a Go application. It will include the necessary resources such as the Elastic Beanstalk application, environment, and an S3 bucket to store the application version. The configuration will also set up an IAM role for the Elastic Beanstalk service to interact with other AWS services. The program will use the AWS provider and specify a default region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "beanstalk_role" {
  name = "beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "beanstalk_policy" {
  name = "beanstalk-service-policy"
  role = aws_iam_role.beanstalk_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "cloudwatch:*",
          "autoscaling:*",
          "elasticbeanstalk:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "go-app-bucket-${random_id.bucket_id.hex}"
}

resource "random_id" "bucket_id" {
  byte_length = 8
}

resource "aws_elastic_beanstalk_application" "go_app" {
  name        = "go-app"
  description = "Elastic Beanstalk Application for Go"
}

resource "aws_elastic_beanstalk_environment" "go_env" {
  name                = "go-env"
  application         = aws_elastic_beanstalk_application.go_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Go 1.16"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_role.beanstalk_role.name
  }
}

resource "aws_elastic_beanstalk_application_version" "go_app_version" {
  application = aws_elastic_beanstalk_application.go_app.name
  version_label = "v1"
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "go-app-v1.zip"

  depends_on = [aws_s3_bucket_object.go_app_zip]
}

resource "aws_s3_bucket_object" "go_app_zip" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "go-app-v1.zip"
  source = "path/to/your/go-app-v1.zip"
}
```
</iac_template>