variable "region" {
  type    = string
  default = "us-east-1"
}
variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_cidr1" {
  type    = string
  default = "10.0.1.0/24"
}
variable "public_cidr2" {
  type    = string
  default = "10.0.2.0/24"
}
variable "public_cidr3" {
  type    = string
  default = "10.0.3.0/24"
}
variable "private_cidr1" {
  type    = string
  default = "10.0.11.0/24"
}
variable "private_cidr2" {
  type    = string
  default = "10.0.12.0/24"
}
variable "private_cidr3" {
  type    = string
  default = "10.0.13.0/24"
}
variable "max_size" {
  type    = string
  default = "2"
}
variable "min_size" {
  type    = string
  default = "1"
}
variable "desired_capacity" {
  type    = string
  default = "1"
}
variable "ssl_cert" {
  type    = string
  default = "unused"
}
variable "db_credentials" {
  type    = string
  default = "benchmark/weasel-crm-rds-credentials"
}
variable "s3_bucket_name" {
  type    = string
  default = "benchmark-weasel-crm-bucket"
}

variable "tags" {
  type    = map(string)
  default = { Environment = "benchmark" }
}
