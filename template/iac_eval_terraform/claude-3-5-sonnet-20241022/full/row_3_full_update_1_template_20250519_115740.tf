I'll help you create a Terraform configuration that sets up a Route 53 weighted routing policy to distribute traffic between three RDS replica instances across different regions, with a primary database in us-west-1.

The configuration will:
1. Create a primary RDS instance in us-west-1
2. Create three read replicas in different regions
3. Set up a Route 53 hosted zone
4. Configure weighted routing policy to distribute traffic between the replicas

Here's the complete configuration:

<iac_template>
# Provider configurations
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

# Variables
variable "db_instance_class" {
  default = "db.t3.medium"
}

variable "db_name" {
  default = "mydb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "password123!" # Change this in production
}

# Route 53 zone
resource "aws_route53_zone" "main" {
  provider = aws.main
  name     = "main.example.com"
}

# Primary DB instance
resource "aws_db_instance" "primary" {
  provider                = aws.main
  identifier             = "primary"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = 20
  storage_type           = "gp2"
  multi_az              = false
  publicly_accessible    = true
  skip_final_snapshot    = true
}

# US East Replica
resource "aws_db_instance" "replica_us_east" {
  provider                = aws.us-east
  identifier             = "replica-us-east"
  instance_class         = var.db_instance_class
  replicate_source_db    = aws_db_instance.primary.arn
  auto_minor_version_upgrade = true
  publicly_accessible    = true
}

# EU Central Replica
resource "aws_db_instance" "replica_eu_central" {
  provider                = aws.eu-central
  identifier             = "replica-eu-central"
  instance_class         = var.db_instance_class
  replicate_source_db    = aws_db_instance.primary.arn
  auto_minor_version_upgrade = true
  publicly_accessible    = true
}

# AP Southeast Replica
resource "aws_db_instance" "replica_ap_southeast" {
  provider                = aws.ap-southeast
  identifier             = "replica-ap-southeast"
  instance_class         = var.db_instance_class
  replicate_source_db    = aws_db_instance.primary.arn
  auto_minor_version_upgrade = true
  publicly_accessible    = true
}

# Route 53 weighted records
resource "aws_route53_record" "replica_us_east" {
  provider = aws.main
  zone_id  = aws_route53_zone.main.zone_id
  name     = "db.main.example.com"
  type     = "CNAME"
  ttl      = "300"
  weighted_routing_policy {
    weight = 33
  }
  set_identifier = "us-east"
  records        = [aws_db_instance.replica_us_east.endpoint]
}

resource "aws_route53_record" "replica_eu_central" {
  provider = aws.main
  zone_id  = aws_route53_zone.main.zone_id
  name     = "db.main.example.com"
  type     = "CNAME"
  ttl      = "300"
  weighted_routing_policy {
    weight = 33
  }
  set_identifier = "eu-central"
  records        = [aws_db_instance.replica_eu_central.endpoint]
}

resource "aws_route53_record" "replica_ap_southeast" {
  provider = aws.main
  zone_id  = aws_route53_zone.main.zone_id
  name     = "db.main.example.com"
  type     = "CNAME"
  ttl      = "300"
  weighted_routing_policy {
    weight = 34
  }
  set_identifier = "ap-southeast"
  records        = [aws_db_instance.replica_ap_southeast.endpoint]
}
</iac_template>

This configuration creates:
1. Four AWS providers for different regions
2. A Route 53 hosted zone named "main.example.com"
3. A primary RDS instance in us-west-1
4. Three read replicas in us-east-1, eu-central-1, and ap-southeast-1
5. Route 53 weighted routing records that distribute traffic approximately equally between the three replicas (33/33/34 split)

Note: 
- You should change the default password in a production environment
- The domain "main.example.com" should be replaced with your actual domain
- You might need to adjust the instance class and storage settings based on your needs
- Make sure you have appropriate IAM permissions to create these resources
- The configuration assumes public accessibility for the databases; adjust this based on your security requirements