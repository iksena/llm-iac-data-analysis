provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "eb_instance_role" {
  name = "ec2_eb_profile1"

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

resource "aws_iam_role_policy_attachment" "eb_instance_role_policy" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "ec2_eb_profile1"
  role = aws_iam_role.eb_instance_role.name
}

resource "aws_db_instance" "my_db" {
  identifier              = "my-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "my_db"
  username                = "admin"
  password                = "password123"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
}

resource "aws_db_snapshot" "my_db_snapshot" {
  db_instance_identifier = aws_db_instance.my_db.id
  db_snapshot_identifier = "my-db-snapshot"
}

resource "aws_elastic_beanstalk_application" "app" {
  name = "my-app"
}

resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "my-app-blue"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
}

resource "aws_elastic_beanstalk_environment" "green" {
  name                = "my-app-green"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
}