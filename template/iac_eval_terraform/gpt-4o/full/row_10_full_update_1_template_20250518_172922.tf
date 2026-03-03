The Terraform program will create an AWS Elastic Beanstalk environment with an associated application and application version. It will also set up the necessary IAM roles and instance profiles for the Elastic Beanstalk environment. The program will create an S3 bucket to store the application version source bundle. The IAM role will be named "eb_ec2_role", and the instance profile will be named "eb_ec2_profile". The Elastic Beanstalk application will be named "myapp", and the application version will be named "version". The S3 bucket will be named "sampleapril26426", and the object within the bucket will be named "examplebucket_object".

<iac_template>
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

resource "aws_iam_role_policy_attachment" "eb_ec2_role_policy" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = "sampleapril26426"
}

resource "aws_s3_bucket_object" "app_object" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "examplebucket_object"
  source = "path/to/your/application.zip"
}

resource "aws_elastic_beanstalk_application" "myapp" {
  name = "myapp"
}

resource "aws_elastic_beanstalk_application_version" "version" {
  name        = "version"
  application = aws_elastic_beanstalk_application.myapp.name
  bucket      = aws_s3_bucket.app_bucket.bucket
  key         = aws_s3_bucket_object.app_object.key
}

resource "aws_elastic_beanstalk_environment" "myapp_env" {
  name                = "myapp-env"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.4 running Node.js 14"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}
</iac_template>