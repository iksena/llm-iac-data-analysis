provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west_1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "us_west_2"
  region = "us-west-2"
}

# Variables
variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "multi-region-table"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "production"
}

# DynamoDB Table in us-east-1
resource "aws_dynamodb_table" "table_us_east_1" {
  provider         = aws.us_east_1
  name             = "${var.table_name}-us-east-1"
  billing_mode     = "PROVISIONED"
  read_capacity    = 5
  write_capacity   = 5
  hash_key         = "ID"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "ID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Environment = var.environment
    Region      = "us-east-1"
  }
}

# DynamoDB Table in us-west-1
resource "aws_dynamodb_table" "table_us_west_1" {
  provider         = aws.us_west_1
  name             = "${var.table_name}-us-west-1"
  billing_mode     = "PROVISIONED"
  read_capacity    = 5
  write_capacity   = 5
  hash_key         = "ID"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "ID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Environment = var.environment
    Region      = "us-west-1"
  }
}

# DynamoDB Table in us-west-2
resource "aws_dynamodb_table" "table_us_west_2" {
  provider         = aws.us_west_2
  name             = "${var.table_name}-us-west-2"
  billing_mode     = "PROVISIONED"
  read_capacity    = 5
  write_capacity   = 5
  hash_key         = "ID"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "ID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = {
    Environment = var.environment
    Region      = "us-west-2"
  }
}