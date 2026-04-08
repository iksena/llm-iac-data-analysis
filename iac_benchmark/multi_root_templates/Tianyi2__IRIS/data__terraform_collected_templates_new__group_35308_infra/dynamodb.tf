resource "aws_dynamodb_table" "playbook_versions" {
  name           = "playbook_versions"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "PlaybookId"
  range_key      = "Version"

  attribute {
    name = "PlaybookId"
    type = "S"
  }

  attribute {
    name = "Version"
    type = "S"
  }

  attribute {
    name = "OrganisationId"
    type = "S"
  }

  global_secondary_index {
    name            = "OrganisationPlaybooks"
    hash_key        = "OrganisationId"
    range_key       = "PlaybookId"
    write_capacity  = 5
    read_capacity   = 5
    projection_type = "ALL"
  }

  // Playbook
}