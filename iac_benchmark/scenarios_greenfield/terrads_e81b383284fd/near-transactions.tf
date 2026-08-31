######## Transactions Table (name=near-transactions)
resource "aws_dynamodb_table" "near-transactions" {
  name         = "near-transactions"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "transactionId"

  attribute {
    name = "transactionId"
    type = "S"
  }

  attribute {
    name = "senderWalletId"
    type = "S"
  }

  attribute {
    name = "receiverWalletId"
    type = "S"
  }

  attribute {
    name = "jobId"
    type = "S"
  }

  attribute {
  name = "parentId"
  type = "S"
  }
  
  attribute {
    name = "created"
    type = "N"
  }

  global_secondary_index {
    name               = "senderWalletId-Index"
    hash_key           = "senderWalletId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "receiverWalletId-Index"
    hash_key           = "receiverWalletId"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "jobId-created-Index"
    hash_key           = "jobId"
    range_key          = "created"
    projection_type    = "ALL"
  }

  global_secondary_index {
    name               = "parentId-created-Index"
    hash_key           = "parentId"
    range_key          = "created"
    projection_type    = "ALL"
  }

  
  tags = {
    Name        = "near-transactions"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    } 

}
