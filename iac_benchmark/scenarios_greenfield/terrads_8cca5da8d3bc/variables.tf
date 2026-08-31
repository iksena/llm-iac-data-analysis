variable "aws_region" {
  description = "TFE region where to deploy the resources"
  default     = "us-east-1"
}

variable "storage_bucket" {
  description = "The name of the S3 Bucket to save all the TFE data to"
  default     = "benchmark-tfe-storage"
}

variable "db_identifier" {
  description = "The DB identifier name"
  default     = "benchmark-tfe-db"
}

variable "db_name" {
  description = "The DB name"
  default     = "tfedb"
}

variable "db_username" {
  description = "The DB username"
  default     = "tfeadmin"
}

variable "db_password" {
  description = "The DB password"
  default     = "BenchmarkPassw0rd!"
}

variable "eks_desired_size" {
  description = "The DB password"
  default     = 2
}

variable "eks_max_size" {
  description = "The DB password"
  default     = 3
}

variable "eks_min_size" {
  description = "The DB password"
  default     = 1
}
