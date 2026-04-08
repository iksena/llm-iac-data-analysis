resource "aws_s3_bucket" "ssh_public_keys" {
  bucket_prefix = "ssh-keys-"
}

resource "aws_s3_bucket_acl" "ssh_public_keys" {
  bucket = aws_s3_bucket.ssh_public_keys.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "ssh_public_keys" {
  bucket = aws_s3_bucket.ssh_public_keys.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "ssh_public_keys" {
  bucket = aws_s3_bucket.ssh_public_keys.bucket
  key    = "authorized_keys"

  content = join(
    "",
    [
      for name in var.authorized_key_names :
      "# ${name}\n${file("${var.authorized_keys_directory}/${name}.pub")}\n"
    ]
  )
  acl = "public-read"
}
