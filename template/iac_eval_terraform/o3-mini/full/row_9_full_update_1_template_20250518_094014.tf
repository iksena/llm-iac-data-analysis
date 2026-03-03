Below is a description of the Terraform program followed by the full HCL code.

Description:
• The configuration begins with an AWS provider set to the us-east-1 region.
• We define an S3 bucket named "sampleapril26426" along with an S3 object "examplebucket_object" (with dummy content) that holds the application source bundle.
• A Simple Queue Service (SQS) queue named "batch_job_queue" is created.
• An Elastic Beanstalk application called "batch_job_app" is declared.
• An application version resource "version" is defined, pointing to the earlier S3 bucket and object.
• An IAM role "eb_ec2_role" is created for EC2 with a trust policy for EC2 service along with a role policy attachment for the AWS managed policy "AWSElasticBeanstalkWorkerTier". An instance profile "eb_ec2_profile" is created using that role.
• Finally, an Elastic Beanstalk environment is provisioned to act as a worker environment (using the "Worker" tier) that uses the application version and configures the SQS queue URL as the worker job source. The environment’s option settings include the IAM instance profile passed to the launch configuration.

Below is the complete deployable Terraform HCL:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# S3 bucket to store the application source bundle
resource "aws_s3_bucket" "app_bucket" {
  bucket = "sampleapril26426"
  acl    = "private"
}

# S3 object representing the application source bundle
resource "aws_s3_object" "app_object" {
  bucket      = aws_s3_bucket.app_bucket.bucket
  key         = "examplebucket_object"
  content     = "This is a dummy application source bundle for Elastic Beanstalk worker environment."
  content_type = "text/plain"
}

# SQS queue to be used by the Elastic Beanstalk worker
resource "aws_sqs_queue" "batch_job_queue" {
  name = "batch_job_queue"
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "batch_job_app" {
  name        = "batch_job_app"
  description = "Elastic Beanstalk application for batch processing jobs."
}

# Elastic Beanstalk Application Version
resource "aws_elastic_beanstalk_application_version" "version" {
  application = aws_elastic_beanstalk_application.batch_job_app.name
  version_label = "version"
  bucket       = aws_s3_bucket.app_bucket.bucket
  key          = aws_s3_object.app_object.key

  lifecycle {
    # Prevent deletion of a version if it is currently in use by an environment
    create_before_destroy = true
  }
}

# IAM Role for EC2 instances in the EB environment
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AWS managed policy for Elastic Beanstalk Worker to the role
resource "aws_iam_role_policy_attachment" "eb_ec2_role_attachment" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

# IAM Instance Profile for EC2 instances in the EB environment
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Elastic Beanstalk Worker Environment
resource "aws_elastic_beanstalk_environment" "worker_env" {
  name                = "batch_job_worker_env"
  application         = aws_elastic_beanstalk_application.batch_job_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.1.0 running Python"  # Use appropriate stack
  
  version_label = aws_elastic_beanstalk_application_version.version.version_label

  setting {
    namespace  = "aws:elasticbeanstalk:environment"
    name       = "EnvironmentType"
    value      = "Worker"
  }

  setting {
    namespace  = "aws:elasticbeanstalk:sqsd"
    name       = "WorkerQueueURL"
    value      = aws_sqs_queue.batch_job_queue.id
  }

  setting {
    namespace  = "aws:autoscaling:launchconfiguration"
    name       = "IamInstanceProfile"
    value      = aws_iam_instance_profile.eb_ec2_profile.name
  }
}
</iac_template>