To fulfill the business need, we will create an AWS Elastic Beanstalk application using Terraform. This configuration will include the creation of an Elastic Beanstalk application, an application version, and an environment. Additionally, we will set up an application version lifecycle policy to manage the application versions automatically. The configuration will use the AWS provider and will be deployed in the `us-west-2` region. We will also define an IAM role and instance profile required for the Elastic Beanstalk environment.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "eb_role" {
  name = "elastic_beanstalk_service_role"

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

resource "aws_iam_role_policy_attachment" "eb_role_policy" {
  role       = aws_iam_role.eb_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "elastic_beanstalk_instance_profile"
  role = aws_iam_role.eb_role.name
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = "example-app"
  description = "An example Elastic Beanstalk application"
}

resource "aws_elastic_beanstalk_application_version" "example" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.example.name
  bucket      = aws_s3_bucket.example.bucket
  key         = aws_s3_bucket_object.example.key
}

resource "aws_elastic_beanstalk_environment" "example" {
  name                = "example-env"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = "example-app"
  description = "An example Elastic Beanstalk application"
}

resource "aws_elastic_beanstalk_application_version_lifecycle" "example" {
  application = aws_elastic_beanstalk_application.example.name

  max_count_rule {
    enabled = true
    max_count = 10
    delete_source_from_s3 = true
  }

  max_age_rule {
    enabled = true
    max_age_in_days = 30
    delete_source_from_s3 = true
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "example-app-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_object" "example" {
  bucket = aws_s3_bucket.example.bucket
  key    = "example-app-v1.zip"
  source = "path/to/your/application.zip"
}
```
</iac_template>

This Terraform configuration sets up an Elastic Beanstalk application with a version lifecycle policy to manage application versions. It includes the necessary IAM roles and instance profiles, and it assumes that the application source code is uploaded to an S3 bucket. Adjust the `source` path in the `aws_s3_bucket_object` resource to point to your actual application package.