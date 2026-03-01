provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "redshift_sns_role" {
  name = "RedshiftSNSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "redshift_sns_policy" {
  name   = "RedshiftSNSPolicy"
  role   = aws_iam_role.redshift_sns_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_sns_topic" "redshift_events" {
  name = "redshift-events-topic"
}

resource "aws_redshift_cluster" "example" {
  cluster_identifier = "example-cluster"
  node_type          = "dc2.large"
  master_username    = "adminuser"
  master_password    = "Admin12345"
  cluster_type       = "single-node"
  iam_roles          = [aws_iam_role.redshift_sns_role.arn]
}

resource "aws_redshift_event_subscription" "example" {
  name                   = "example-subscription"
  sns_topic_arn          = aws_sns_topic.redshift_events.arn
  source_type            = "cluster"
  source_ids             = [aws_redshift_cluster.example.id]
  event_categories       = ["configuration", "management", "monitoring", "security"]
  severity               = "INFO"
  enabled                = true
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.redshift_events.arn
  protocol  = "email"
  endpoint  = "example@example.com"  # Replace with a valid email address
}