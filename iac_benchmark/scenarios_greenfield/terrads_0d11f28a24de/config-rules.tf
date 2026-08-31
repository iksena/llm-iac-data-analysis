module "aws_config_rules_us_east_1" {
  source                        = "StratusGrid/config-rules/aws"
  version                       = "1.3.1"
  include_global_resource_rules = true #only include global resource on one region to prevent duplicate rules
  required_tags_enabled         = true
  required_tags = {
    tag1Key   = "AWS_Backup" # Yes, the actual required format is tag#Key and the required key
    tag1Value = true
    tag2Key   = "Environment"
  }

  # tag1Key   = "Provisioner"
  # tag1Value = "Terraform"
  # tag2Key   = "Customer"
  # tag3Key   = "Application"

  providers = {
    aws = aws.us-east-1
  }
}

/*
module "aws_config_recorder_us_east_2" {
  source        = "StratusGrid/config-recorder/aws"
  version       = "1.3.1"
  log_bucket_id = module.s3_bucket_logging_us_east_2.bucket_id
  providers = {
    aws = aws.us-east-2
  }
}
*/

/*
module "aws_config_recorder_us_west_1" {
  source        = "StratusGrid/config-recorder/aws"
  version       = "1.3.1"
  log_bucket_id = module.s3_bucket_logging_us_west_1.bucket_id
  providers = {
    aws = aws.us-west-1
  }
}
*/

/*
module "aws_config_recorder_us_west_2" {
  source        = "StratusGrid/config-recorder/aws"
  version       = "1.3.1"
  log_bucket_id = module.s3_bucket_logging_us_west_2.bucket_id
  providers = {
    aws = aws.us-west-2
  }
}
*/