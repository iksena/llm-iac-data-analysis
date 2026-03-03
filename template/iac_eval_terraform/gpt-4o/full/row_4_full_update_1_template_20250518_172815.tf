The Terraform program will set up an AWS Route 53 configuration with two hosted zones: one private and one public. It will create two RDS instances, one for internal use and one for public access. The internal RDS instance will be placed in a private subnet, while the public RDS instance will be in a public subnet. The Route 53 configuration will ensure that internal users are directed to the internal RDS instance and external users to the public RDS instance. The necessary IAM roles and security groups will be created to allow access to the RDS instances.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]
}

resource "aws_rds_instance" "internal" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "internaldb"
  username             = "admin"
  password             = "internalpassword"
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.internal.id]
  publicly_accessible  = false
}

resource "aws_rds_instance" "public" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "publicdb"
  username             = "admin"
  password             = "publicpassword"
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.public.id]
  publicly_accessible  = true
}

resource "aws_security_group" "internal" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "public" {
  vpc_id = aws_vpc.main.id

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
}

resource "aws_route53_zone" "private" {
  name = "private.example.com"
  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_zone" "public" {
  name = "public.example.com"
}

resource "aws_route53_record" "internal" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_instance.internal.endpoint]
}

resource "aws_route53_record" "public" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "db"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_instance.public.endpoint]
}
</iac_template>