# ── main.tf ────────────────────────────────────
# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Create a S3 bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket		  = "${var.bucket_name}"
  
  versioning {
    enabled = true
  }  
  
  lifecycle {
    prevent_destroy = true
  }
}



# ── outputs.tf ────────────────────────────────────
# Output variable: S3 bucket
output "s3_bucket_arn" {
  value = "${aws_s3_bucket.terraform_state.arn}"
}


# ── vars.tf ────────────────────────────────────
# Input variable: S3 bucket name
variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  default = "terraform-state-my-bucket"
}
