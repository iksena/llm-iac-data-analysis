resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "real-time-offers-archive-${random_id.suffix.hex}"
  force_destroy = true
}
