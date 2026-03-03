<iac_template>
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Main provider using us-west-1 for primary resources and route53 hosted zone.
provider "aws" {
  alias  = "main"
  region = "us-west-1"
}

# Provider for us-east-1.
provider "aws" {
  alias  = "us-east"
  region = "us-east-1"
}

# Provider for eu-central-1.
provider "aws" {
  alias  = "eu-central"
  region = "eu-central-1"
}

# Provider for ap-southeast-1.
provider "aws" {
  alias  = "ap-southeast"
  region = "ap-southeast-1"
}

# Create a Route 53 hosted zone called "main" in us-west-1.
resource "aws_route53_zone" "main" {
  provider = aws.main
  name     = "main.example.com"
}

# Create primary DB instance in us-west-1.
resource "aws_db_instance" "primary" {
  provider            = aws.main
  identifier          = "primary-db"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  username            = "admin"
  password            = "Password123!"
  skip_final_snapshot = true
  deletion_protection = true
}

# Create replica in us-east-1.
resource "aws_db_instance" "replica_us_east" {
  provider            = aws.us-east
  identifier          = "replica-us-east"
  engine              = aws_db_instance.primary.engine
  engine_version      = aws_db_instance.primary.engine_version
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  
  # Note: Do not specify username or password when using replicate_source_db.
  skip_final_snapshot = true

  depends_on = [aws_db_instance.primary]
}

# Create replica in eu-central-1.
resource "aws_db_instance" "replica_eu_central" {
  provider            = aws.eu-central
  identifier          = "replica-eu-central"
  engine              = aws_db_instance.primary.engine
  engine_version      = aws_db_instance.primary.engine_version
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  
  skip_final_snapshot = true

  depends_on = [aws_db_instance.primary]
}

# Create replica in ap-southeast-1.
resource "aws_db_instance" "replica_ap_southeast" {
  provider            = aws.ap-southeast
  identifier          = "replica-ap-southeast"
  engine              = aws_db_instance.primary.engine
  engine_version      = aws_db_instance.primary.engine_version
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  
  skip_final_snapshot = true

  depends_on = [aws_db_instance.primary]
}

# Configure a weighted Route 53 record for the replica in us-east-1.
resource "aws_route53_record" "weighted_replica_us_east" {
  provider      = aws.main
  zone_id       = aws_route53_zone.main.zone_id
  name          = "db.main.example.com"
  type          = "CNAME"
  ttl           = 60
  records       = [aws_db_instance.replica_us_east.endpoint]
  set_identifier = "replica_us_east"

  weighted_routing_policy {
    weight = 33
  }
}

# Configure a weighted Route 53 record for the replica in eu-central-1.
resource "aws_route53_record" "weighted_replica_eu_central" {
  provider      = aws.main
  zone_id       = aws_route53_zone.main.zone_id
  name          = "db.main.example.com"
  type          = "CNAME"
  ttl           = 60
  records       = [aws_db_instance.replica_eu_central.endpoint]
  set_identifier = "replica_eu_central"

  weighted_routing_policy {
    weight = 33
  }
}

# Configure a weighted Route 53 record for the replica in ap-southeast-1.
resource "aws_route53_record" "weighted_replica_ap_southeast" {
  provider      = aws.main
  zone_id       = aws_route53_zone.main.zone_id
  name          = "db.main.example.com"
  type          = "CNAME"
  ttl           = 60
  records       = [aws_db_instance.replica_ap_southeast.endpoint]
  set_identifier = "replica_ap_southeast"

  weighted_routing_policy {
    weight = 34
  }
}
</iac_template>