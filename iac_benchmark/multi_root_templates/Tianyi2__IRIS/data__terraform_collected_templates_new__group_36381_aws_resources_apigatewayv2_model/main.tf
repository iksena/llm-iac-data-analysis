terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  alias  = "region"
  region = var.region
}

resource "aws_apigatewayv2_model" "this" {
  api_id       = var.api_id
  content_type = var.content_type
  name         = var.name
  schema       = var.schema
  description  = var.description

  provider = aws.region
}