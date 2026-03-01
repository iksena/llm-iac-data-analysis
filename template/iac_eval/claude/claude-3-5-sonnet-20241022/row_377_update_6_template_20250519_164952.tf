provider "aws" {
  region = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the Lightsail bucket"
  type        = string
  default     = "my-lightsail-content-bucket"
}

variable "distribution_name" {
  description = "Name of the Lightsail distribution"
  type        = string
  default     = "my-lightsail-distribution"
}

resource "aws_lightsail_bucket" "content_bucket" {
  name      = var.bucket_name
  bundle_id = "small_1_0"
}

resource "aws_lightsail_distribution" "cdn_distribution" {
  name      = var.distribution_name
  bundle_id = "small_1_0"

  origin {
    name        = "BucketOrigin"
    region_name = "us-east-1"
    source_name = aws_lightsail_bucket.content_bucket.name
  }

  default_cache_behavior {
    behavior = "cache"
  }
}

output "distribution_domain_name" {
  description = "Domain name of the Lightsail distribution"
  value       = aws_lightsail_distribution.cdn_distribution.domain_name
}

output "bucket_name" {
  description = "Name of the Lightsail bucket"
  value       = aws_lightsail_bucket.content_bucket.name
}