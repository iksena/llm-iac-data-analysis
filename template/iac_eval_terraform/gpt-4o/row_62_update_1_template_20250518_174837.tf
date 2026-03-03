provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"

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

resource "aws_iam_policy" "firehose_policy" {
  name        = "firehose_delivery_policy"
  description = "Policy for Kinesis Firehose to deliver data to OpenSearch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "es:ESHttpPost",
          "es:ESHttpPut"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attachment" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_policy.arn
}

resource "aws_opensearch_domain" "example" {
  domain_name = "example-domain"

  cluster_config {
    instance_type = "t3.small.search"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
  }
}

resource "aws_kinesis_firehose_delivery_stream" "firehose_to_opensearch" {
  name        = "firehose-to-opensearch"
  destination = "opensearch"

  opensearch_configuration {
    role_arn           = aws_iam_role.firehose_role.arn
    domain_arn         = aws_opensearch_domain.example.arn
    index_name         = "my-index"
    type_name          = "_doc"
    buffering_interval = 300
    buffering_size     = 5
  }
}