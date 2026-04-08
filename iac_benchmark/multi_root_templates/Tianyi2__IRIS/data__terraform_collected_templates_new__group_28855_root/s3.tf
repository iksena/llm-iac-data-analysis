resource "aws_s3_bucket" "ssh_public_keys" {
  bucket_prefix = "ssh-keys-"
  acl           = "public-read"
  website {
    index_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "ssh_public_keys" {
  bucket = aws_s3_bucket.ssh_public_keys.bucket
  key    = "authorized_keys"

  content = join(
    "",
    [
      for name in var.authorized_key_names:
      "# ${name}\n${file("${var.authorized_keys_directory}/${name}.pub")}\n"
    ]
  )
  depends_on = [aws_s3_bucket.ssh_public_keys]
  acl        = "public-read"
}
