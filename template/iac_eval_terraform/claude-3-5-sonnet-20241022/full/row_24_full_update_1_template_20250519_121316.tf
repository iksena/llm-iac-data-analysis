I'll help you create a Terraform configuration that sets up Route 53, Elastic Beanstalk with an EC2 instance profile, and RDS database integration. Here's what the configuration will do:

1. Create an Elastic Beanstalk application and environment
2. Set up an RDS database instance
3. Configure Route 53 records to point to the Elastic Beanstalk environment
4. Create necessary IAM roles and instance profiles
5. Configure security groups for RDS and Elastic Beanstalk communication

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  description = "Domain name for the application"
  default     = "example.com"
}

variable "environment" {
  description = "Environment name"
  default     = "myenv"
}

# IAM Role for EC2 instances
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb-ec2-role"

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

# IAM instance profile
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile1"
  role = aws_iam_role.eb_ec2_role.name
}

# Attach necessary policies to the role
resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.eb_ec2_role.name
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.eb_sg.id]
  }
}

# Security group for Elastic Beanstalk
resource "aws_security_group" "eb_sg" {
  name        = "eb-security-group"
  description = "Security group for Elastic Beanstalk environment"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Instance
resource "aws_db_instance" "myapp_db" {
  identifier           = "myapp-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "password123!" # Change this in production
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "myapp" {
  name        = "my-app"
  description = "My Application"
}

# Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "myenv" {
  name                = var.environment
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_sg.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = aws_db_instance.myapp_db.endpoint
  }
}

# Route 53 record
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_elastic_beanstalk_environment.myenv.cname
    zone_id               = data.aws_route53_zone.selected.zone_id
    evaluate_target_health = true
  }
}

# Data source for Route 53 zone
data "aws_route53_zone" "selected" {
  name = var.domain_name
}
</iac_template>

This configuration creates:
1. An IAM role and instance profile for EC2 instances in Elastic Beanstalk
2. Security groups for both RDS and Elastic Beanstalk
3. An RDS MySQL database named "myapp_db"
4. An Elastic Beanstalk application and environment named "myenv"
5. A Route 53 record pointing to the Elastic Beanstalk environment

Important notes:
1. You'll need to change the RDS password in production
2. Make sure to replace the domain_name variable with your actual domain
3. The Route 53 zone must exist before applying this configuration
4. The solution stack name might need to be updated based on your application requirements
5. Additional security group rules might be needed based on your specific requirements

To use this configuration:
1. Save it to a .tf file
2. Initialize Terraform with `terraform init`
3. Review the planned changes with `terraform plan`
4. Apply the configuration with `terraform apply`