Below is an improved version of the Terraform configuration. In this version the appversion_lifecycle block is configured using flat attributes (max_age_in_days, max_count, and delete_source_from_s3) rather than nested blocks for max_age_rule and max_count_rule, which is supported in the current AWS provider. Deploy this template with your AWS credentials.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

variable "application_name" {
  description = "Name of the Elastic Beanstalk Application"
  type        = string
  default     = "MyEBApplication"
}

resource "aws_iam_role" "eb_service_role" {
  name = "elasticbeanstalk-service-role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ElasticBeanstalkServiceRole"
  }
}

resource "aws_elastic_beanstalk_application" "my_app" {
  name        = var.application_name
  description = "Elastic Beanstalk Application with version lifecycle management"

  appversion_lifecycle {
    service_role          = aws_iam_role.eb_service_role.arn
    max_age_in_days       = 30
    max_count             = 200
    delete_source_from_s3 = true
  }

  tags = {
    Environment = "Production"
  }
}
</iac_template>