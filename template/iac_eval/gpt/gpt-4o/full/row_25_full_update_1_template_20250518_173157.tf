The Terraform program will set up a multi-region application deployment using AWS Elastic Beanstalk environments in the "us-east-1" and "eu-west-1" regions. Each environment will have a connected RDS database. AWS Route 53 will be used to manage a domain and direct traffic to these environments. The Elastic Beanstalk environments will be named "myenv_us_east" and "myenv_eu_west", and the applications will be named "myapp_us_east" and "myapp_eu_west". The instance profile for EC2 instances in Elastic Beanstalk will be "eb_ec2_profile3". The RDS databases will be named "main_db_us_east" and "main_db_eu_west". The configuration will include IAM roles and policies as needed.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"
}

resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role3"

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

resource "aws_iam_role_policy_attachment" "eb_ec2_role_policy" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile3"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_elastic_beanstalk_application" "us_east_app" {
  name = "myapp_us_east"
}

resource "aws_elastic_beanstalk_application" "eu_west_app" {
  provider = aws.eu-west-1
  name     = "myapp_eu_west"
}

resource "aws_elastic_beanstalk_environment" "us_east_env" {
  name                = "myenv_us_east"
  application         = aws_elastic_beanstalk_application.us_east_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}

resource "aws_elastic_beanstalk_environment" "eu_west_env" {
  provider            = aws.eu-west-1
  name                = "myenv_eu_west"
  application         = aws_elastic_beanstalk_application.eu_west_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}

resource "aws_db_instance" "us_east_db" {
  identifier              = "main_db_us_east"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  name                    = "mydb"
  username                = "admin"
  password                = "password123"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
}

resource "aws_db_instance" "eu_west_db" {
  provider                = aws.eu-west-1
  identifier              = "main_db_eu_west"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  name                    = "mydb"
  username                = "admin"
  password                = "password123"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
}

resource "aws_route53_zone" "main" {
  name = "example.com"
}

resource "aws_route53_record" "us_east" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "us-east-1.example.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_elastic_beanstalk_environment.us_east_env.endpoint_url]
}

resource "aws_route53_record" "eu_west" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "eu-west-1.example.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_elastic_beanstalk_environment.eu_west_env.endpoint_url]
}
</iac_template>