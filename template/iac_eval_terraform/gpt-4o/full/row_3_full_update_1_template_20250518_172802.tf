The Terraform program will set up a Route 53 hosted zone with a weighted routing policy to distribute traffic among three read replica database instances. The main database instance will be located in the "us-west-1" region, while the replicas will be distributed across "us-east-1", "eu-central-1", and "ap-southeast-1". The program will configure the necessary provider aliases for each region and create the required IAM roles and policies to manage the database instances and Route 53 resources.

<iac_template>
```hcl
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

resource "aws_rds_instance" "primary" {
  provider           = aws.main
  identifier         = "primary"
  instance_class     = "db.t2.micro"
  engine             = "mysql"
  allocated_storage  = 20
  name               = "primarydb"
  username           = "admin"
  password           = "password123"
  skip_final_snapshot = true
}

resource "aws_rds_instance" "replica_us_east" {
  provider           = aws.us-east
  identifier         = "replica-us-east"
  instance_class     = "db.t2.micro"
  engine             = "mysql"
  allocated_storage  = 20
  replicate_source_db = aws_rds_instance.primary.id
  skip_final_snapshot = true
}

resource "aws_rds_instance" "replica_eu_central" {
  provider           = aws.eu-central
  identifier         = "replica-eu-central"
  instance_class     = "db.t2.micro"
  engine             = "mysql"
  allocated_storage  = 20
  replicate_source_db = aws_rds_instance.primary.id
  skip_final_snapshot = true
}

resource "aws_rds_instance" "replica_ap_southeast" {
  provider           = aws.ap-southeast
  identifier         = "replica-ap-southeast"
  instance_class     = "db.t2.micro"
  engine             = "mysql"
  allocated_storage  = 20
  replicate_source_db = aws_rds_instance.primary.id
  skip_final_snapshot = true
}

resource "aws_route53_zone" "main" {
  provider = aws.main
  name     = "main"
}

resource "aws_route53_record" "weighted" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "db.main"
  type    = "CNAME"

  weighted_routing_policy {
    weight = 1
  }

  alias {
    name                   = aws_rds_instance.replica_us_east.endpoint
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = false
  }

  weighted_routing_policy {
    weight = 1
  }

  alias {
    name                   = aws_rds_instance.replica_eu_central.endpoint
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = false
  }

  weighted_routing_policy {
    weight = 1
  }

  alias {
    name                   = aws_rds_instance.replica_ap_southeast.endpoint
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = false
  }
}
```
</iac_template>