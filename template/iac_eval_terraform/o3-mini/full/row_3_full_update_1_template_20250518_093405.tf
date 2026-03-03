Below is a complete Terraform configuration that creates a Route 53 hosted zone called “main” (using a FQDN “main.example.com” for a valid domain name), a primary DB instance (in us‑west‑1 using provider alias “main”), and three read‐replica DB instances – one each in us‑east‑1, eu‑central‑1, and ap‑southeast‑1 (using providers “us‑east”, “eu‑central” and “ap‑southeast” respectively). It then creates three Route 53 record resources (with equal weighted routing policies) that serve as CNAME records (all with the same name “db”) pointing users to the replica endpoints. (Note that for a real deployment you might need additional parameters and security considerations; this sample provides default credentials/values so that the configuration is self-contained and deployable.) 

<iac_template>
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
</iac_template>

This configuration meets the business need: provisioning the primary DB and zone in us-west-1, deploying three replicas in the respective regions via provider aliases, and setting up a Route 53 weighted routing policy over the replica endpoints.