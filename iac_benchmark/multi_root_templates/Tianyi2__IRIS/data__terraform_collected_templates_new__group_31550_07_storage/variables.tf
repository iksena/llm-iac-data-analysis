variable "region" {
  type    = string
  default = "us-east-1"
}

variable "school" {
  type    = string
  default = "cesi"
}

variable "project" {
  type    = string
  default = "07-storage"
}

# TODO: update the S3 bucket names below with your bucket names
variable "bucket_source" {
  type    = string
  default = "ysimiandcossin-source"
}

variable "bucket_target" {
  type    = string
  default = "ysimiandcossin-target"
}
