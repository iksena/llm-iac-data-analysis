Below is a description of the Terraform program that meets your business need:

• The AWS provider is configured in us-east-1.  
• A Route 53 hosted zone named “main” (managing example.com) is created. A CNAME record in the hosted zone directs traffic (using “www.example.com”) to the endpoint of an Elastic Beanstalk environment.  
• An S3 bucket with a unique name is created using a random identifier. A sample S3 object “examplebucket_object” is added to the bucket.  
• An IAM role (“eb_ec2_role”) suitable for EC2 is created along with an IAM instance profile (“eb_ec2_profile”).  
• An Elastic Beanstalk application (“myapp”) is defined along with an application version (“version”) that uses the S3 bucket and object for its source bundle.  
• Finally, an Elastic Beanstalk environment (“eb-env”) is created using the application, a default solution stack, and the instance profile attached to the environment’s EC2 resources.

Below is the complete deployable Terraform HCL template:

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Generate a random suffix for unique bucket naming
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create an S3 bucket with a unique name
resource "aws_s3_bucket" "bucket" {
  bucket = "my-unique-bucket-${random_id.bucket_suffix.hex}"
  acl    = "private"
  force_destroy = true
}

# Add an object to the S3 bucket
resource "aws_s3_object" "examplebucket_object" {
  bucket = aws_s3_bucket.bucket.bucket
  key    = "examplebucket_object"
  content = "This is an example object for Elastic Beanstalk application version."
  acl     = "private"
}

# Create IAM Role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach a commonly used managed policy for EC2 (optional: adjust policies as needed)
resource "aws_iam_role_policy_attachment" "eb_ec2_managed" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Create IAM Instance Profile for Elastic Beanstalk EC2 instances
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Create an Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "myapp" {
  name        = "myapp"
  description = "Elastic Beanstalk Application for my app"
}

# Create an Elastic Beanstalk Application Version using the S3 object
resource "aws_elastic_beanstalk_application_version" "version" {
  name        = "version"
  application = aws_elastic_beanstalk_application.myapp.name

  bucket = aws_s3_bucket.bucket.bucket
  key    = aws_s3_object.examplebucket_object.key

  description = "Application Version using S3 bucket object"
  
  depends_on = [aws_s3_object.examplebucket_object]
}

# Create an Elastic Beanstalk Environment. Here we use a common solution stack for demonstration.
resource "aws_elastic_beanstalk_environment" "eb-env" {
  name                = "eb-env"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v3.1.7 running Python 3.8"
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
  
  # Tie the environment to our application version.
  version_label = aws_elastic_beanstalk_application_version.version.name

  depends_on = [aws_elastic_beanstalk_application_version.version]
}

# Create a Route53 Hosted Zone managing the domain "example.com"
resource "aws_route53_zone" "main" {
  name = "example.com."
}

# Create a CNAME record that directs "www.example.com" to the Elastic Beanstalk environment endpoint
resource "aws_route53_record" "eb_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  records = [aws_elastic_beanstalk_environment.eb-env.endpoint_url]
}
</iac_template>