provider for primary region
provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table with replica configuration
resource "aws_dynamodb_table" "global_table" {
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

  lifecycle {
    ignore_changes = [replica]
  }
}