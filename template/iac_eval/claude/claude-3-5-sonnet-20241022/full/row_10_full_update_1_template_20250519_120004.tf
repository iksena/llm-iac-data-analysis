I'll help you create a Terraform configuration for an AWS Elastic Beanstalk environment with the specified components. This configuration will:

1. Create an IAM role and instance profile for EC2 instances
2. Create an S3 bucket and upload an object (application version)
3. Create an Elastic Beanstalk application
4. Create an Elastic Beanstalk application version
5. Create an Elastic Beanstalk environment

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for EC2 instances
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

# Attach policies to IAM role
resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Create EC2 instance profile
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Create S3 bucket
resource "aws_s3_bucket" "application_bucket" {
  bucket = "sampleapril26426"
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.application_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Upload sample application to S3
resource "aws_s3_object" "examplebucket_object" {
  bucket = aws_s3_bucket.application_bucket.id
  key    = "sample-app.zip"
  source = "sample-app.zip"  # Make sure this file exists in your local directory
}

# Create Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "myapp" {
  name        = "myapp"
  description = "Sample application"
}

# Create Elastic Beanstalk application version
resource "aws_elastic_beanstalk_application_version" "version" {
  name        = "version"
  application = aws_elastic_beanstalk_application.myapp.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.application_bucket.id
  key         = aws_s3_object.examplebucket_object.key
}

# Create Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "myapp_environment" {
  name                = "myapp-environment"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"
  version_label      = aws_elastic_beanstalk_application_version.version.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }
}
</iac_template>

Note: This configuration assumes you have a file named "sample-app.zip" in your local directory that contains your application code. You'll need to provide this file or modify the S3 object configuration accordingly.

The configuration creates:
1. An IAM role with the necessary permissions for Elastic Beanstalk
2. An instance profile that uses the IAM role
3. An S3 bucket to store the application version
4. An S3 object for the application code
5. An Elastic Beanstalk application
6. An application version
7. An Elastic Beanstalk environment using the Node.js platform

The environment is configured with:
- t2.micro instances
- Auto-scaling group with min=1 and max=2 instances
- The specified IAM instance profile
- Node.js 18 platform

Make sure to:
1. Have AWS credentials configured
2. Have the sample-app.zip file in your working directory
3. Modify the region if needed
4. Adjust the solution stack name if you want to use a different platform