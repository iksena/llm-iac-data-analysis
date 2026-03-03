provider "aws" {
  region = "us-east-1"  # Lightsail is available in us-east-1
}

# Variables with default values
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

# Create Lightsail Bucket
resource "aws_lightsail_bucket" "content_bucket" {
  name      = var.bucket_name
  bundle_id = "small_1_0"  # 1TB storage with 100GB monthly transfer
  tags = {
    Environment = "Production"
  }
}

# Enable bucket public access
resource "aws_lightsail_bucket_access_key" "bucket_access" {
  bucket_name = aws_lightsail_bucket.content_bucket.name
}

resource "aws_lightsail_bucket_resource_access" "bucket_access" {
  bucket_name = aws_lightsail_bucket.content_bucket.name
  access      = "public"
}

# Create Lightsail Distribution
resource "aws_lightsail_distribution" "cdn_distribution" {
  name = var.distribution_name
  
  bundle_id = "small_1_0"
  
  origin {
    name        = "BucketOrigin"
    region_name = "us-east-1"
    
    bucket_name = aws_lightsail_bucket.content_bucket.name
  }

  default_cache_behavior {
    behavior = "cache"
    
    forwarded_cookies {
      option = "none"
    }
    
    forwarded_headers {
      option = "none"
    }
    
    forwarded_query_strings {
      option = false
    }
  }

  cache_behavior_settings {
    default_ttl = 86400    # 24 hours
    maximum_ttl = 31536000 # 1 year
    minimum_ttl = 0
  }

  certificate {
    name = null
  }

  tags = {
    Environment = "Production"
  }
}

# Output values
output "distribution_domain_name" {
  description = "Domain name of the Lightsail distribution"
  value       = aws_lightsail_distribution.cdn_distribution.domain_name
}

output "bucket_name" {
  description = "Name of the Lightsail bucket"
  value       = aws_lightsail_bucket.content_bucket.name
}