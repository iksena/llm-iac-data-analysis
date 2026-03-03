terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region for deployment."
  type        = string
  default     = "us-east-1"
}

resource "aws_iam_role" "lex_v2_bot_role" {
  name = "lex_v2_bot_role"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "lex.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_lexv2_models_bot" "children" {
  name                        = "children"
  description                 = "Amazon Lex V2 bot for children"
  role_arn                    = aws_iam_role.lex_v2_bot_role.arn
  idle_session_ttl_in_seconds = 300

  data_privacy {
    child_directed = true
  }
}