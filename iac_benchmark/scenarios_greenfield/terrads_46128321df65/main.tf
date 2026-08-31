terraform {
  required_version = ">= 1.7.5"
}

provider "aws" {
  region                   = "eu-west-1"
}

provider "aws" {
  alias   = "dublin"
  region  = "eu-west-1"
}
provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
}
provider "aws" {
  alias   = "mumbai"
  region  = "ap-south-1"
}