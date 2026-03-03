To fulfill the business need, we will set up an AWS RDS Aurora MySQL cluster with a proxy for enhanced connection management. The infrastructure will include a VPC with public and private subnets, security groups to control access, IAM roles for necessary permissions, and AWS Secrets Manager to securely store database credentials. The configuration will be deployed in the `us-east-1` region.

The Terraform program will include:
1. A VPC with public and private subnets.
2. Security groups for the RDS cluster and the proxy.
3. An RDS Aurora MySQL cluster.
4. An RDS Proxy for connection management.
5. IAM roles and policies for RDS and Secrets Manager.
6. AWS Secrets Manager to store the database credentials securely.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "rds" {
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

resource "aws_rds_cluster" "aurora" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.10.2"
  master_username         = "admin"
  master_password         = "aurora_password"
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
}

resource "aws_db_subnet_group" "main" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.private.id]
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = 2
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = "db.r5.large"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "aurora-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = "aurora_password"
  })
}

resource "aws_iam_role" "rds_proxy_role" {
  name = "rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_proxy_policy" {
  role       = aws_iam_role.rds_proxy_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSFullAccess"
}

resource "aws_db_proxy" "aurora_proxy" {
  name                   = "aurora-proxy"
  engine_family          = "MYSQL"
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [aws_security_group.rds.id]
  vpc_subnet_ids         = [aws_subnet.private.id]

  auth {
    secret_arn = aws_secretsmanager_secret.db_credentials.arn
    iam_auth   = "DISABLED"
  }
}
```
</iac_template>