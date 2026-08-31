######## SharedFiles Table (name=near-shared-files)
resource "aws_dynamodb_table" "near-shared-files" {
  name         = "near-shared-files"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "fileId"
  range_key = "userId"

  attribute {
    name = "fileId"
    type = "S"
  }
   
   attribute {
    name = "userId"
    type = "S"
  } 

  tags = {
    Name        = "near-shared-files"
    Environment = var.environment
  }

   lifecycle {
    prevent_destroy = true
    } 

}