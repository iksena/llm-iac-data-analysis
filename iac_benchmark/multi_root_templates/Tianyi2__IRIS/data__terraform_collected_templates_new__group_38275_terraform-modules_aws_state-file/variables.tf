
variable "iam_principals" {
  description = "A list of IAM user or role ARNs that will have access to the state S3 bucket"
  type        = list(string)
}

variable "state_bucket_kms_key_id" {
  description = "The KMS key ID used to encrypt the S3 state bucket. Uses AWS-managed key if not specified."
  type        = string
  default     = ""
}

variable "create_dynamodb_table" {
  description = "Whether to create the DynamoDB table used for Terraform state locking."
  type        = bool
  default     = true
}

variable "region_name" {
  description = "Name of the region that the state file is responsible for"
  type        = string
}
