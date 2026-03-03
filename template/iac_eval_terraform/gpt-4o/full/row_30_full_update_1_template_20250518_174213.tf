To address the business need of deploying and scaling a web application, we will provision an AWS Elastic Beanstalk environment. AWS Elastic Beanstalk is a Platform as a Service (PaaS) that supports several programming languages and allows for easy deployment and scaling of web applications. We will create an Elastic Beanstalk application and environment, along with the necessary IAM roles for the application and service. The configuration will be set up in the `us-west-2` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "eb_service_role" {
  name = "eb_service_role"

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

resource "aws_iam_role_policy_attachment" "service_role_policy" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb_instance_profile"
  role = aws_iam_role.eb_service_role.name
}

resource "aws_elastic_beanstalk_application" "web_app" {
  name        = "my-web-app"
  description = "Elastic Beanstalk Application for my web app"
}

resource "aws_elastic_beanstalk_environment" "web_app_env" {
  name                = "my-web-app-env"
  application         = aws_elastic_beanstalk_application.web_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Node.js 14"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
}
```
</iac_template>

This Terraform configuration sets up an Elastic Beanstalk application and environment for a Node.js web application. It includes the necessary IAM roles and policies to allow Elastic Beanstalk to manage resources on your behalf. The environment is configured to be load-balanced, which allows for scaling as needed.