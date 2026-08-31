# Create network
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "daniela-vpc"
  }
}

resource "aws_subnet" "publicsub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "daniela-public-subnet1"
  }
}

resource "aws_subnet" "publicsub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "daniela-public-subnet2"
  }
}

resource "aws_subnet" "privatesub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "daniela-private-subnet1"
  }
}

resource "aws_subnet" "privatesub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "daniela-private-subnet2"
  }
}


resource "aws_internet_gateway" "internetgw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "daniela-internet-gateway"
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetgw.id
  }

  tags = {
    Name = "daniela-route"
  }
}

resource "aws_route_table_association" "route_association1" {
  subnet_id      = aws_subnet.publicsub1.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "route_association2" {
  subnet_id      = aws_subnet.publicsub2.id
  route_table_id = aws_route_table.route.id
}

resource "aws_security_group" "securitygp" {

  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "https-access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh-access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "db-access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "redis-access"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "redis-int-access"
    from_port   = 6380
    to_port     = 6380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "vault-access"
    from_port   = 8201
    to_port     = 8201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "egress-rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    type = "daniela-security-group"
  }
}


# Create External Services: AWS S3 Bucket
resource "aws_s3_bucket" "s3bucket_data" {
  bucket        = var.storage_bucket
  force_destroy = true

  tags = {
    Name        = "Daniela FDO Storage"
    Environment = "Dev"
  }
}

# commenting this out cause i am giving permissions in the cluster already
# # Create roles and policies to have access to the S3 bucket
# resource "aws_iam_role_policy" "daniela-policy" {
#   name = "daniela-policy-docker"
#   role = aws_iam_role.daniela_node_role.id

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "VisualEditor0",
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:PutObject",
#           "s3:GetObject",
#           "s3:ListBucket",
#           "s3:DeleteObject",
#           "s3:GetBucketLocation"
#         ],
#         "Resource" : [
#           "arn:aws:s3:::tfe-bucket",
#         ]
#       },
#       {
#         "Sid" : "VisualEditor1",
#         "Effect" : "Allow",
#         "Action" : "s3:ListAllMyBuckets",
#         "Resource" : "*"
#       }
#     ]
#   })
# }

# Create External Services: Postgres 14.x DB
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "daniela-db-subnetgroup"
  subnet_ids = [aws_subnet.publicsub1.id, aws_subnet.privatesub1.id]

  tags = {
    Name = "daniela-db-subnet-group"
  }
}


resource "aws_db_instance" "tfe_db" {
  allocated_storage      = 400
  identifier             = var.db_identifier
  db_name                = var.db_name
  engine                 = "postgres"
  engine_version         = "14.9"
  instance_class         = "db.m5.xlarge"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres14"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.securitygp.id]
}

# Create Redis instance
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "daniela-redis-subnetgroup"
  subnet_ids = [aws_subnet.publicsub1.id, aws_subnet.privatesub1.id]
}

resource "aws_elasticache_cluster" "tfe_redis" {
  cluster_id           = "daniela-tfe-redis"
  engine               = "redis"
  node_type            = "cache.t3.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  security_group_ids   = [aws_security_group.securitygp.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
}