variable "region" {
  type    = string
  default = "us-west-1"

  validation {
    condition = substr(var.region, 0, 3) == "us-"
    error_message = "The region must start with \"us-\"."
  }
}

variable "vpc_cidr" {
  default = {
    prod = "10.10.0.0/16"
    dev  = "10.20.0.0/16"
  } 
  type = map(string)
}
