provider for primary region
provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}

# Configure AWS provider for secondary region
provider "aws" {
  region = "us-west-2"
  alias  = "secondary"
}

# Create DynamoDB table in primary region
resource "aws_dynamodb_table" "primary" {
  provider = aws.primary

  name             = "global-table-example"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  replica {
    region_name = "us-west-2"
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = "Production"
    Purpose     = "Global Table Example"
  }
}

# Create DynamoDB table replica in secondary region
resource "aws_dynamodb_table_replica" "replica" {
  provider         = aws.secondary
  global_table_arn = aws_dynamodb_table.primary.arn
  
  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Environment = "Production"
    Purpose     = "Global Table Replica"
  }
}