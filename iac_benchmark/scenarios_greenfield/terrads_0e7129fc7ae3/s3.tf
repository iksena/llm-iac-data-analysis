#tfsec:ignore:aws-s3-specify-public-access-block
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-no-public-buckets
#tfsec:ignore:aws-s3-ignore-public-acls
#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-block-public-policy
#tfsec:ignore:aws-s3-block-public-acls
resource "aws_s3_bucket" "main" {
  bucket        = local.bootcamp_id
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "main" {
  depends_on = [aws_s3_bucket_ownership_controls.main]

  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object" "ssh_key" {

  for_each = toset(var.ec2_instances)

  bucket  = aws_s3_bucket.main.id
  key     = "ssh-key-${each.key}.pem"
  content = tls_private_key.main[each.key].private_key_pem

  depends_on = [
    aws_s3_bucket.main
  ]
}
