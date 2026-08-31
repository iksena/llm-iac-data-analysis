variable "aws_region" {
  description = "The AWS region"
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "The project credentials profile"
  default     = "enchant3dmango"
}

variable "aws_s3_esdiel_bucket" {
  description = "The source bucket name"
  default     = "esdiel-bucket"
}

variable "aws_s3_esdiel_bucket_transformed" {
  description = "The target bucket name"
  default     = "esdiel-bucket-transformed"
}

variable "aws_glue_database_name" {
  description = "The name of the Glue database"
  default     = "esdiel_db"
}

variable "aws_glue_etl_job_name" {
  description = "The name of the Glue job"
  default     = "Transform Esdiel data"
}

variable "aws_glue_iam_role_name" {
  description = "The name of IAM Role of Glue"
  default     = "EsdielGlueRole"
}

variable "aws_glue_etl_script_location" {
  description = "The S3 location of the Glue script"
  default     = "s3://esdiel-bucket/scripts/glue_etl_script.py"
}

variable "aws_glue_table_raw" {
  description = "The Glue table name for Esdiel raw data"
  default     = "esdiel_data_raw"
}

variable "aws_glue_table_transformed" {
  description = "The Glue table name for Esdiel transformed data"
  default     = "esdiel_data_transformed"
}

variable "aws_lambda_function_name" {
  description = "The function name of Lambda"
  default     = "esdiel-handler"
}

variable "aws_lambda_role_name" {
  description = "The name of IAM Role of Lambda"
  default     = "EsdielLambdaRole"
}
