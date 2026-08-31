provider "aws" {
  # allowed_account_ids = var.account_numbers
  region = var.region
}

#Extra Providers for Config and other Multi-Region configurations like AWS Config
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  # allowed_account_ids = var.account_numbers
}

/*
provider "aws" {
  alias               = "us-east-2"
  region              = "us-east-2"
  allowed_account_ids = var.account_numbers
}
*/

/*
provider "aws" {
  alias               = "us-west-1"
  region              = "us-west-1"
  allowed_account_ids = var.account_numbers
}
*/

/*
provider "aws" {
 alias               = "us-west-2"
 region              = "us-west-2"
 allowed_account_ids = var.account_numbers
}
*/