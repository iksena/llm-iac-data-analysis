# ── main.tf ────────────────────────────────────
module "aws_reverse_proxy" {
  # Available inputs: https://github.com/futurice/terraform-utils/tree/master/aws_reverse_proxy#inputs
  # Check for updates: https://github.com/futurice/terraform-utils/compare/v11.0...master
  source = "git::ssh://git@github.com/futurice/terraform-utils.git//aws_reverse_proxy?ref=v11.0"

  origin_url             = "http://example.com/"           # note that this is just a dummy value to satisfy CloudFront, it won't ever be used with the override_* variables in place
  site_domain            = "${var.redirect_domain}"
  name_prefix            = "${var.name_prefix}"
  comment_prefix         = "${var.comment_prefix}"
  cloudfront_price_class = "${var.cloudfront_price_class}"
  viewer_https_only      = "${var.viewer_https_only}"
  lambda_logging_enabled = "${var.lambda_logging_enabled}"
  tags                   = "${var.tags}"

  add_response_headers = {
    "Strict-Transport-Security" = "${var.redirect_with_hsts ? "max-age=31557600; preload" : ""}"
    "Location"                  = "${var.redirect_url}"
  }

  override_response_status             = "${var.redirect_permanently ? "301" : "302"}"
  override_response_status_description = "${var.redirect_permanently ? "Moved Permanently" : "Found"}"

  override_response_body = <<EOF
  <!doctype html>
  <html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Redirecting</title>
  </head>
  <body>
    <pre>Redirecting to: <a href="${var.redirect_url}">${var.redirect_url}</a></pre>
  </body>
  EOF
}


# ── variables.tf ────────────────────────────────────
variable "redirect_domain" {
  description = "Domain which will redirect to the given `redirect_url`; e.g. `\"docs.example.com\"`"
}

variable "redirect_url" {
  description = "The URL this domain redirect should send clients to; e.g. `\"https://readthedocs.org/projects/example\"`"
}

variable "name_prefix" {
  description = "Name prefix to use for objects that need to be created (only lowercase alphanumeric characters and hyphens allowed, for S3 bucket name compatibility)"
  default     = "aws-domain-redirect---"
}

variable "comment_prefix" {
  description = "This will be included in comments for resources that are created"
  default     = "Domain redirect: "
}

variable "cloudfront_price_class" {
  description = "Price class to use (`100`, `200` or `\"All\"`, see https://aws.amazon.com/cloudfront/pricing/)"
  default     = 100
}

variable "viewer_https_only" {
  description = "Set this to `false` if you need to support insecure HTTP access for clients, in addition to HTTPS"
  default     = true
}

variable "redirect_permanently" {
  description = "Which HTTP status code to use for the redirect; if `true`, uses `301 Moved Permanently`, instead of `302 Found`"
  default     = false
}

variable "redirect_with_hsts" {
  description = "Whether to send the `Strict-Transport-Security` header with the redirect (recommended for security)"
  default     = true
}

variable "lambda_logging_enabled" {
  description = "When `true`, writes information about incoming requests to the Lambda function's CloudWatch group"
  default     = false
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = "map"
  default     = {}
}
