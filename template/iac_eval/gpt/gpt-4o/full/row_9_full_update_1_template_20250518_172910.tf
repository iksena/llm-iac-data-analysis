The Terraform program will create an AWS Elastic Beanstalk worker environment designed for running batch processing jobs. It will include the necessary IAM roles and instance profiles, an S3 bucket for storing application versions, an SQS queue for job processing, and an Elastic Beanstalk application with a specific version. The configuration will ensure that all resources are correctly linked and deployable within a specified AWS region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eb_ec2_policy" {
  name = "eb_ec2_policy"
  role = aws_iam_role.eb_ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "sqs:*",
          "cloudwatch:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_s3_bucket" "sampleapril26426" {
  bucket = "sampleapril26426"
}

resource "aws_s3_bucket_object" "examplebucket_object" {
  bucket = aws_s3_bucket.sampleapril26426.id
  key    = "examplebucket_object"
  source = "path/to/your/application.zip"
}

resource "aws_sqs_queue" "batch_job_queue" {
  name = "batch_job_queue"
}

resource "aws_elastic_beanstalk_application" "batch_job_app" {
  name = "batch_job_app"
}

resource "aws_elastic_beanstalk_application_version" "version" {
  name        = "version"
  application = aws_elastic_beanstalk_application.batch_job_app.name
  bucket      = aws_s3_bucket.sampleapril26426.id
  key         = aws_s3_bucket_object.examplebucket_object.id
}

resource "aws_elastic_beanstalk_environment" "worker_environment" {
  name                = "batch-job-worker-env"
  application         = aws_elastic_beanstalk_application.batch_job_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Corretto 11"

  setting {
    namespace = "aws:elasticbeanstalk:sqsd"
    name      = "WorkerQueueURL"
    value     = aws_sqs_queue.batch_job_queue.id
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SQS_QUEUE_URL"
    value     = aws_sqs_queue.batch_job_queue.id
  }

  version_label = aws_elastic_beanstalk_application_version.version.name
}
```
</iac_template>