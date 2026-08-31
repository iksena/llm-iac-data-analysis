data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  common_tags = {
    manage_by = "terraform",
    owner     = "tavares"
  }
}