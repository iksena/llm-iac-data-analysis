Below is an explanation of the Terraform program followed by the complete HCL configuration. This configuration creates a new VPC with two subnets (so that the RDS subnet group “main” has the required subnets) and then builds two RDS instances – one internal (not publicly accessible) and one public – both using the subnet group named “main.” It then creates two Route 53 hosted zones. The “private” zone (with domain name private.example.com) is a private hosted zone associated with the VPC so that only internal users will resolve it, and the “public” zone (domain name public.example.com) is public. Finally, DNS records (named “db”) in each zone point to the corresponding RDS database endpoints. (Note: Domain names “private” and “public” by themselves are not valid FQDNs, so the zones use “private.example.com” and “public.example.com” to maintain the naming intent while ensuring a deployable configuration.) 

Below is the full Terraform configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# Create a VPC for our resources
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Create two subnets in different AZs for high availability
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet2"
  }
}

# Create the DB subnet group "main" using the two subnets
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  tags = {
    Name = "main"
  }
}

# Create the internal RDS instance (not publicly accessible)
resource "aws_db_instance" "internal" {
  identifier               = "internal"
  engine                   = "mysql"
  engine_version           = "8.0"
  instance_class           = "db.t3.micro"
  allocated_storage        = 20
  username                 = var.db_username
  password                 = var.db_password
  db_subnet_group_name     = aws_db_subnet_group.main.name
  publicly_accessible      = false
  skip_final_snapshot      = true
  deletion_protection      = false

  tags = {
    Name = "internal-database"
  }
}

# Create the public RDS instance (publicly accessible)
resource "aws_db_instance" "public" {
  identifier               = "public"
  engine                   = "mysql"
  engine_version           = "8.0"
  instance_class           = "db.t3.micro"
  allocated_storage        = 20
  username                 = var.db_username
  password                 = var.db_password
  db_subnet_group_name     = aws_db_subnet_group.main.name
  publicly_accessible      = true
  skip_final_snapshot      = true
  deletion_protection      = false

  tags = {
    Name = "public-database"
  }
}

# Create a private Route 53 hosted zone named "private"
resource "aws_route53_zone" "private_zone" {
  name = "private.example.com"

  vpc {
    vpc_id = aws_vpc.main_vpc.id
  }

  tags = {
    Name = "private"
  }
}

# Create a public Route 53 hosted zone named "public"
resource "aws_route53_zone" "public_zone" {
  name = "public.example.com"

  tags = {
    Name = "public"
  }
}

# Create a DNS record in the private zone pointing to the internal RDS endpoint
resource "aws_route53_record" "internal_db_record" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.internal.address]
}

# Create a DNS record in the public zone pointing to the public RDS endpoint
resource "aws_route53_record" "public_db_record" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.public.address]
}

# Variables with default values
variable "region" {
  description = "The AWS region to deploy in"
  default     = "us-east-1"
}

variable "db_username" {
  description = "The database username"
  default     = "admin"
}

variable "db_password" {
  description = "The database password"
  default     = "password123"  # For production, do NOT hardcode credentials.
}
</iac_template>

This complete Terraform configuration sets up the necessary networking, RDS instances, DB subnet group, and Route 53 hosted zones and DNS records so that internal clients (via the private zone) resolve the internal database while external clients (via the public zone) resolve the public database endpoint.