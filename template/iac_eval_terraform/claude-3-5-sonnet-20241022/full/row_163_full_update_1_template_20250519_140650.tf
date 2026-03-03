I'll help you create a DynamoDB Table that will be deployed across three AWS regions: us-east-1, us-west-1, and us-west-2. The configuration will use multiple provider configurations to deploy the same table structure across these regions.

Description:
This Terraform configuration will:
1. Set up AWS providers for three different regions
2. Create identical DynamoDB tables in each region
3. Configure the tables with:
   - A primary key (partition key) named "ID"
   - Basic provisioned capacity (5 read and 5 write capacity units)
   - Point-in-time recovery enabled
   - Server-side encryption enabled
   - Tags for environment tracking

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Providers for different regions
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
</iac_template>

This configuration creates three identical DynamoDB tables, one in each specified region. Each table:
- Has a unique name based on the region
- Uses provisioned capacity with 5 read and 5 write capacity units
- Has a primary key named "ID" of type String
- Has point-in-time recovery enabled
- Uses server-side encryption
- Includes DynamoDB Streams
- Has appropriate tags for environment and region identification

To deploy this configuration, you'll need:
1. AWS credentials configured with appropriate permissions
2. Terraform installed on your local machine
3. Run the standard Terraform workflow commands (init, plan, apply)

The tables will be created independently in each region, providing multi-region availability for your data.