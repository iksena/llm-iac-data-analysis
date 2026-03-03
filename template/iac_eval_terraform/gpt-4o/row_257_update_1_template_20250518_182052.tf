provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "redshift_sns_role" {
  name = "RedshiftSNSRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "redshift_sns_policy" {
  name = "RedshiftSNSPolicy"
  role = aws_iam_role.redshift_sns_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_sns_topic" "redshift_events" {
  name = "redshift-events-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.redshift_events.arn
  protocol  = "email"
  endpoint  = "example@example.com"  # Replace with your email address
}

resource "aws_redshift_cluster" "example" {
  cluster_identifier = "example-cluster"
  node_type          = "dc2.large"
  master_username    = "adminuser"
  master_password    = "Admin12345"  # Replace with a secure password
  cluster_type       = "single-node"
  iam_roles          = [aws_iam_role.redshift_sns_role.arn]

  tags = {
    Name = "example-cluster"
  }
}

resource "aws_redshift_event_subscription" "example" {
  name                   = "example-event-subscription"
  sns_topic_arn          = aws_sns_topic.redshift_events.arn
  source_type            = "cluster"
  source_ids             = [aws_redshift_cluster.example.id]
  event_categories       = ["configuration", "management", "monitoring", "security"]
  severity               = "INFO"
  enabled                = true
}