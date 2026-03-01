Below is a description of the Terraform program followed by the complete HCL configuration. This program creates the following resources:

• An AWS provider in the us-east-1 region along with data sources to look up the default VPC and its subnets.
• An RDS DB subnet group and a security group for the RDS instances.
• Two RDS instances using MySQL – one for production (identifier "prod_db") and one for staging (identifier "staging_db"). Both instances are configured with default connection parameters.
• An IAM role (assumed by Elastic Beanstalk EC2 instances) and an instance profile named "eb_ec2_profile".
• Two Elastic Beanstalk applications (for production and staging).
• Two Elastic Beanstalk environments, one each for production and staging. The environment option settings configure the instance to use the "eb_ec2_profile" as its IAM instance profile and inject the RDS connection details (hostname, database name, username, and password) into the application environment.

Below is the complete Terraform configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Get default VPC and its subnets for use by the RDS instances
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Create a DB subnet group using the default VPC subnets
resource "aws_db_subnet_group" "default" {
  name       = "default-dbsubnet-group"
  subnet_ids = data.aws_subnet_ids.default.ids

  tags = {
    Name = "Default DB Subnet Group"
  }
}

# Create an RDS security group to control access to the database (for demonstration, open to 0.0.0.0/0 on mysql port)
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS instances"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

# Create the production RDS instance
resource "aws_db_instance" "prod_db" {
  identifier              = "prod_db"
  allocated_storage       = 5
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "productiondb"
  username                = "admin"
  password                = "password"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  tags = {
    Name = "Production DB"
  }
}

# Create the staging RDS instance
resource "aws_db_instance" "staging_db" {
  identifier              = "staging_db"
  allocated_storage       = 5
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "stagingdb"
  username                = "admin"
  password                = "password"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  tags = {
    Name = "Staging DB"
  }
}

# Create the IAM role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_role" {
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

# Create the instance profile "eb_ec2_profile"
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_role.name
}

# Create Elastic Beanstalk production application
resource "aws_elastic_beanstalk_application" "prod_app" {
  name        = "prod_app"
  description = "Production Elastic Beanstalk Application"
}

# Create Elastic Beanstalk staging application
resource "aws_elastic_beanstalk_application" "staging_app" {
  name        = "staging_app"
  description = "Staging Elastic Beanstalk Application"
}

# Create production Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "prod_env" {
  name                = "prod_env"
  application         = aws_elastic_beanstalk_application.prod_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOSTNAME"
    value     = aws_db_instance.prod_db.address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_DB_NAME"
    value     = aws_db_instance.prod_db.identifier
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USERNAME"
    value     = aws_db_instance.prod_db.username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = aws_db_instance.prod_db.password
  }
}

# Create staging Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "staging_env" {
  name                = "staging_env"
  application         = aws_elastic_beanstalk_application.staging_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOSTNAME"
    value     = aws_db_instance.staging_db.address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_DB_NAME"
    value     = aws_db_instance.staging_db.identifier
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USERNAME"
    value     = aws_db_instance.staging_db.username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = aws_db_instance.staging_db.password
  }
}
</iac_template>