provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu_west"
  region = "eu-west-1"
}

# Variables
variable "domain_name" {
  type    = string
  default = "example.com"
}

variable "db_password" {
  type    = string
  default = "defaultpassword123!"
}

# Route 53 Zone
resource "aws_route53_zone" "main" {
  provider = aws.us_east
  name     = var.domain_name
}

# IAM Role and Instance Profile
resource "aws_iam_role" "eb_ec2" {
  provider = aws.us_east
  name     = "eb_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  provider = aws.us_east
  name     = "eb_ec2_profile3"
  role     = aws_iam_role.eb_ec2.name
}

resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  provider   = aws.us_east
  role       = aws_iam_role.eb_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# US East Resources
resource "aws_elastic_beanstalk_application" "us_east" {
  provider = aws.us_east
  name     = "myapp_us_east"
}

resource "aws_db_instance" "us_east" {
  provider             = aws.us_east
  identifier           = "main-db-us-east"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  allocated_storage    = 20
  db_name             = "maindb"
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = true
}

resource "aws_elastic_beanstalk_environment" "us_east" {
  provider    = aws.us_east
  name        = "myenv-us-east"
  application = aws_elastic_beanstalk_application.us_east.name

  solution_stack_name = "64bit Amazon Linux 2 v5.6.1 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}

# EU West Resources
resource "aws_elastic_beanstalk_application" "eu_west" {
  provider = aws.eu_west
  name     = "myapp_eu_west"
}

resource "aws_db_instance" "eu_west" {
  provider             = aws.eu_west
  identifier           = "main-db-eu-west"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  allocated_storage    = 20
  db_name             = "maindb"
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = true
}

resource "aws_elastic_beanstalk_environment" "eu_west" {
  provider    = aws.eu_west
  name        = "myenv-eu-west"
  application = aws_elastic_beanstalk_application.eu_west.name

  solution_stack_name = "64bit Amazon Linux 2 v5.6.1 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}

# Route 53 Records
resource "aws_route53_record" "us_east" {
  provider = aws.us_east
  zone_id  = aws_route53_zone.main.zone_id
  name     = "us-east-1.${var.domain_name}"
  type     = "CNAME"
  ttl      = 300
  records  = [aws_elastic_beanstalk_environment.us_east.cname]
}

resource "aws_route53_record" "eu_west" {
  provider = aws.us_east
  zone_id  = aws_route53_zone.main.zone_id
  name     = "eu-west-1.${var.domain_name}"
  type     = "CNAME"
  ttl      = 300
  records  = [aws_elastic_beanstalk_environment.eu_west.cname]
}