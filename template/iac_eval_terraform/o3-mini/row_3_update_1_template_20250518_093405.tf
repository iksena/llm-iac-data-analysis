terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  alias  = "main"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "eu-central"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "ap-southeast"
  region = "ap-southeast-1"
}

# Create a hosted zone called "main"
resource "aws_route53_zone" "main" {
  provider = aws.main
  name     = "main.example.com"
}

# Create primary DB instance in us-west-1
resource "aws_db_instance" "primary" {
  provider              = aws.main
  identifier            = "primary-db"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  storage_type          = "gp2"
  username              = "admin"
  password              = "Password123!"
  skip_final_snapshot   = true

  # Additional parameters may be required in production.
}

# Create replica in us-east-1
resource "aws_db_instance" "replica_us_east" {
  provider            = aws.us-east
  identifier          = "replica-us-east"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  availability_zone   = "us-east-1a"
  skip_final_snapshot = true
}

# Create replica in eu-central-1
resource "aws_db_instance" "replica_eu_central" {
  provider            = aws.eu-central
  identifier          = "replica-eu-central"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  availability_zone   = "eu-central-1a"
  skip_final_snapshot = true
}

# Create replica in ap-southeast-1
resource "aws_db_instance" "replica_ap_southeast" {
  provider            = aws.ap-southeast
  identifier          = "replica-ap-southeast"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  availability_zone   = "ap-southeast-1a"
  skip_final_snapshot = true
}

# Configure Route53 weighted record for replica in us-east-1
resource "aws_route53_record" "weighted_replica_us_east" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = 60

  records = [
    aws_db_instance.replica_us_east.endpoint
  ]

  set_identifier = "replica_us_east"
  weight         = 33
}

# Configure Route53 weighted record for replica in eu-central-1
resource "aws_route53_record" "weighted_replica_eu_central" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = 60

  records = [
    aws_db_instance.replica_eu_central.endpoint
  ]

  set_identifier = "replica_eu_central"
  weight         = 33
}

# Configure Route53 weighted record for replica in ap-southeast-1
resource "aws_route53_record" "weighted_replica_ap_southeast" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = 60

  records = [
    aws_db_instance.replica_ap_southeast.endpoint
  ]

  set_identifier = "replica_ap_southeast"
  weight         = 34
}