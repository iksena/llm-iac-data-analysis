provider "aws" {
  region = "us-east-2"
}

# Configure AWS Provider for secondary region
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# Create DynamoDB table with replica
resource "aws_dynamodb_table" "example_table" {
  name           = "example-global-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "id"
    type = "S"
  }

  replica {
    region_name = "us-west-2"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
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