locals {
  apigateway_name = var.apigateway_name
}

variable "apigateway_name" { default = "benchmark-api" }
variable "bounded_context" { default = "benchmark" }

variable "is_auth_required" {
  default = true
}

variable "jwt_audience" { default = "benchmark-audience" }
variable "jwt_issuer" { default = "https://benchmark.example.com/" }

variable "aws_account_id" {
  default = "891616054205"
}

variable "organisation" {
  default = "HocVienCongGiao"
}

variable "aws_region" {
  default = "us-west-2"
}
