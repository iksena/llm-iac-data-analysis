variable "resource_prefix" {
  description = "The prefix that will be appended to name of all the resources created"
  type        = string
  default     = "kscope"
}

variable "aws_iam_user" {
  type        = string
  description = "The name of the IAM user whose credentials will be used to crawl resoures. There is only one policy that we attach to this user, the AWS managed read only policy that allows this user to read any resource."
  default     = "crawl-user"
}

variable "cloudtrail_name" {
  type        = string
  description = "The name of the cloudtrail that is used to track the events in your account. For more information on the way this trail is configured, see README"
  default     = "trail"
}

variable "cloudtrail_bucket_name" {
  type        = string
  description = "The name of the s3 bucket that is used by cloudtrail to store its log file. Please note that the eventual name of this resource is {resource_prefix}-{bucket_name} and it has to be globally unique. The default for this is empty. Cloudtrail will only be created when a value for this variable is set."
  default     = ""
}

variable "aws_sqs_queue" {
  description = "The name of the aws sqs queue that subscribes to the EventBridge topic. Kaleidoscope polls this queue to get latest event log files. For more info see README"
  type        = string
  default     = "trail-queue"
}

variable "environment" {
  description = "The name of the environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

locals {
  prefix              = var.resource_prefix
  cloudtrail_name     = "${local.prefix}-${var.cloudtrail_name}"
  aws_s3_bucket       = "${local.prefix}-${var.cloudtrail_bucket_name}"
  aws_iam_user        = "${local.prefix}-${var.aws_iam_user}"
  aws_sqs_queue       = "${var.aws_sqs_queue}-${var.environment}"
}
