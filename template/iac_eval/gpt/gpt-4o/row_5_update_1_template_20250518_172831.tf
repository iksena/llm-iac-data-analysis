provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "main" {
  name = "main"
}

resource "aws_db_instance" "primary" {
  identifier              = "primary"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "primarydb"
  username                = "admin"
  password                = "password123"
  skip_final_snapshot     = true
}

resource "aws_db_instance" "replica_1" {
  identifier              = "replica-1"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  replicate_source_db     = aws_db_instance.primary.id
  skip_final_snapshot     = true
}

resource "aws_db_instance" "replica_2" {
  identifier              = "replica-2"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  replicate_source_db     = aws_db_instance.primary.id
  skip_final_snapshot     = true
}

resource "aws_route53_record" "replica_1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "replica-1.main"
  type    = "CNAME"
  ttl     = 60
  records = [aws_db_instance.replica_1.endpoint]

  weighted_routing_policy {
    weight = 50
  }
}

resource "aws_route53_record" "replica_2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "replica-2.main"
  type    = "CNAME"
  ttl     = 60
  records = [aws_db_instance.replica_2.endpoint]

  weighted_routing_policy {
    weight = 50
  }
}