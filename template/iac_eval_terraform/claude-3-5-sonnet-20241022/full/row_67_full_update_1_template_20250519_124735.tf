I'll help you create a Terraform configuration for an AWS Kinesis Firehose Delivery Stream that delivers data to an OpenSearch cluster within a VPC. This configuration will include:

1. A VPC with public and private subnets
2. An OpenSearch domain within the VPC
3. A Kinesis Firehose delivery stream
4. Necessary IAM roles and policies
5. Security groups and VPC endpoints
6. Required networking components (Internet Gateway, NAT Gateway)

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "opensearch-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "opensearch-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "opensearch-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "opensearch-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "opensearch-nat"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "opensearch-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "opensearch-private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Security Group for OpenSearch
resource "aws_security_group" "opensearch" {
  name        = "opensearch-sg"
  description = "Security group for OpenSearch domain"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}

# OpenSearch Domain
resource "aws_opensearch_domain" "main" {
  domain_name    = "my-opensearch-domain"
  engine_version = "OpenSearch_2.5"

  cluster_config {
    instance_type = "t3.small.search"
  }

  vpc_options {
    subnet_ids         = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.opensearch.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
}

# IAM Role for Firehose
resource "aws_iam_role" "firehose" {
  name = "firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Firehose
resource "aws_iam_role_policy" "firehose" {
  name = "firehose-policy"
  role = aws_iam_role.firehose.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "es:DescribeElasticsearchDomain",
          "es:DescribeElasticsearchDomains",
          "es:DescribeElasticsearchDomainConfig",
          "es:ESHttpPost",
          "es:ESHttpPut",
          "es:ESHttpGet"
        ]
        Resource = [
          aws_opensearch_domain.main.arn,
          "${aws_opensearch_domain.main.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

# VPC Endpoint for Kinesis Firehose
resource "aws_vpc_endpoint" "firehose" {
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.us-west-2.kinesis-firehose"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private.id]
  security_group_ids = [aws_security_group.opensearch.id]
}

# Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "main" {
  name        = "opensearch-stream"
  destination = "elasticsearch"

  elasticsearch_configuration {
    domain_arn = aws_opensearch_domain.main.arn
    role_arn   = aws_iam_role.firehose.arn
    index_name = "test-index"
    type_name  = "_doc"

    buffering_interval = 60
    buffering_size    = 5

    cloudwatch_logging_options {
      enabled = true
      log_group_name = "/aws/firehose/opensearch-stream"
      log_stream_name = "delivery"
    }
  }
}
</iac_template>

This Terraform configuration creates:
1. A VPC with public and private subnets
2. Internet Gateway and NAT Gateway for internet connectivity
3. An OpenSearch domain in the private subnet
4. A Kinesis Firehose delivery stream configured to send data to OpenSearch
5. Necessary IAM roles and policies for Firehose to interact with OpenSearch
6. Security groups and VPC endpoints for secure communication
7. Required networking components including route tables and associations

The configuration is set up in the us-west-2 region and uses t3.small.search instances for OpenSearch. The OpenSearch domain is encrypted at rest and uses TLS for secure communication. The Firehose delivery stream buffers data for 60 seconds or 5 MB before delivering to OpenSearch.

To deploy this configuration, you'll need appropriate AWS credentials and permissions. After deployment, you can send data to the Kinesis Firehose delivery stream, and it will automatically be delivered to the OpenSearch domain within your VPC.