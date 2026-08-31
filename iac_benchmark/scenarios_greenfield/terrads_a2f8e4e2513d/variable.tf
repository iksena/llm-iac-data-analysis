
variable "aws_config_bucket_name" {
    type = string
    description = "the bucket name of aws config. Leave blank to have this module create its own bucket."
    default = ""
}

variable "region" {
  type = string
  description = "the current region of aws"
  default = "us-east-1"
}

variable "admin_email" {
  type = list(string)
  description = "the admin emails, prefer group email instead of personal ones"
  default = ["security-admin@example.com"]
}

