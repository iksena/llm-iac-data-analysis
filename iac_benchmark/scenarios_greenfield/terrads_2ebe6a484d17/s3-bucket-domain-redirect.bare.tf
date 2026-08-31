# Bare domain redirection bucket
resource "aws_s3_bucket" "bare_domain_redirect" {
  provider = aws.us_west_2
  bucket   = "utkusarioglu-com-bare-domain-redirect"
}

# TODO check if this works without a policy attachment
resource "aws_s3_bucket_website_configuration" "bare_domain_redirect" {
  provider = aws.us_west_2
  bucket   = aws_s3_bucket.bare_domain_redirect.bucket
  redirect_all_requests_to {
    host_name = "www.${local.domain_name}"
    protocol  = "https"
  }
}
