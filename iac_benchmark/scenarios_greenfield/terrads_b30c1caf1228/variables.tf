variable "aws_access_key" {
    description = "Access key to AWS console"
    default     = "unused"
}
variable "aws_secret_key" {
    description = "Secret key to AWS console"
    default     = "unused"
}
variable "aws_region"{
    description = "AWS Region Selection"
    default = "us-east-1"
}
variable "aws_key_name" {
    description = "AWS SSH Key Pair Name"
  default     = "unused"
}
variable "name" {
    description = "Name tag assigned to resource"
  default     = "benchmark"
}
variable "api_uri" {
    description = "Target URI for API Gateway"
  default     = "https://example.com/api"
}