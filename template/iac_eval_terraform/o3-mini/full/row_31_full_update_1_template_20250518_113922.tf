Below is the description of the Terraform program that will be generated:

Description:
• The Terraform configuration first sets up the AWS provider, using a default region ("us-east-1").
• A variable "application_name" is defined with a default value ("MyEBApplication") so that the application name can be easily customized.
• An IAM role is created ("aws_iam_role.eb_service_role") to support Elastic Beanstalk lifecycle operations. The role has a trust relationship that allows Elastic Beanstalk to assume the role.
• An Elastic Beanstalk application, "aws_elastic_beanstalk_application.my_app", is then defined. The resource includes an "application_version_lifecycle" block that sets up both a "max_age_rule" and a "max_count_rule" to manage application versions. The IAM service role from the earlier resource is attached via the "service_role" attribute.
• This complete and self-contained configuration can be deployed after initializing and planning with Terraform.

Below is the complete Terraform HCL configuration:

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

  tags = {
    Name = "ElasticBeanstalkServiceRole"
  }
}

resource "aws_elastic_beanstalk_application" "my_app" {
  name        = var.application_name
  description = "Elastic Beanstalk Application with version lifecycle management"

  application_version_lifecycle {
    service_role = aws_iam_role.eb_service_role.name
    
    max_age_rule {
      enabled             = true
      max_age_in_days     = 30
      delete_source_from_s3 = true
    }

    max_count_rule {
      enabled             = true
      max_count           = 200
      delete_source_from_s3 = true
    }
  }

  tags = {
    Environment = "Production"
  }
}
</iac_template>