######## Apps Table (name=near-apps)
resource "aws_dynamodb_table" "near-nft-activities" {
  name         = "near-nft-activities"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "activityId"
  range_key    = "created" 

  attribute {
    name = "activityId"
    type = "S"
  }

  attribute {
    name = "nftId"
    type = "S"
  }

   attribute {
    name = "created"
    type = "N"
  } 

    global_secondary_index {
    name               = "nftId-Index"
    hash_key           = "nftId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "near-nft-activities"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    }  
}