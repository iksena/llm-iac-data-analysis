# ── variables.tf ────────────────────────────────────
variable "site_domain" {
  description = "Domain on which the reverse proxy will be made available (e.g. `\"www.example.com\"`)"
}

variable "name_prefix" {
  description = "Name prefix to use for objects that need to be created (only lowercase alphanumeric characters and hyphens allowed, for S3 bucket name compatibility)"
  default     = "aws-reverse-proxy---"
}

variable "comment_prefix" {
  description = "This will be included in comments for resources that are created"
  default     = "Reverse proxy: "
}

variable "origin_url" {
  description = "Base URL for proxy upstream site (e.g. `\"https://example.com/\"`)"
}

variable "cloudfront_price_class" {
  description = "CloudFront price class to use (`100`, `200` or `\"All\"`, see https://aws.amazon.com/cloudfront/pricing/)"
  default     = 100
}

variable "viewer_https_only" {
  description = "Set this to `false` if you need to support insecure HTTP access for clients, in addition to HTTPS"
  default     = true
}

variable "cache_ttl_override" {
  description = "When >= 0, override the cache behaviour for ALL objects in the origin, so that they stay in the CloudFront cache for this amount of seconds"
  default     = -1
}

variable "default_root_object" {
  description = "The object to return when the root URL is requested"
  default     = ""
}

variable "add_response_headers" {
  description = "Map of HTTP headers (if any) to add to outgoing responses before sending them to clients"
  type        = "map"

  default = {
    "Strict-Transport-Security" = "max-age=31557600; preload" # i.e. 1 year (in seconds)
  }
}

variable "origin_custom_header_name" {
  description = "Name of a custom header to send to the origin; this can be used to convey an authentication header to the origin, for example"

  # Unfortunately, since Terraform doesn't allow conditional inline blocks (yet), we need to ALWAYS have SOME header here.
  # This default one will be sent if a custom one isn't defined, but it's assumed to be harmless.
  default = "X-Custom-Origin-Header"
}

variable "origin_custom_header_value" {
  description = "Value of a custom header to send to the origin; see `origin_custom_header_name`"
  default     = ""
}

variable "origin_custom_port" {
  description = "When > 0, use this port for communication with the origin server, instead of relevant standard port"
  default     = 0
}

variable "override_response_status" {
  description = "When this and the other `override_response_*` variables are non-empty, skip sending the request to the origin altogether, and instead respond as instructed here"
  default     = ""
}

variable "override_response_status_description" {
  description = "Same as `override_response_status`"
  default     = ""
}

variable "override_response_body" {
  description = "Same as `override_response_status`"
  default     = ""
}

variable "basic_auth_username" {
  description = "When non-empty, require this username with HTTP Basic Auth"
  default     = ""
}

variable "basic_auth_password" {
  description = "When non-empty, require this password with HTTP Basic Auth"
  default     = ""
}

variable "basic_auth_realm" {
  description = "When using HTTP Basic Auth, this will be displayed by the browser in the auth prompt"
  default     = "Authentication Required"
}

variable "basic_auth_body" {
  description = "When using HTTP Basic Auth, and authentication has failed, this will be displayed by the browser as the page content"
  default     = "Unauthorized"
}

variable "lambda_logging_enabled" {
  description = "When true, writes information about incoming requests to the Lambda function's CloudWatch group"
  default     = false
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = "map"
  default     = {}
}

locals {
  prefix_with_domain = "${var.name_prefix}${replace("${var.site_domain}", "/[^a-z0-9-]+/", "-")}" # only lowercase alphanumeric characters and hyphens are allowed in S3 bucket names
  error_ttl          = "${var.cache_ttl_override >= 0 ? var.cache_ttl_override : 0}"
}

# Because CloudFront origins expect the URL to be provided as components, we need to do a bit of URL "parsing"
locals {
  url_protocol = "${replace("${var.origin_url}", "/^(?:(\\w+):\\/\\/).*/", "$1")}"
  url_hostname = "${replace("${var.origin_url}", "/^(?:\\w+:\\/\\/)?([^/]+).*/", "$1")}"
  url_path     = "${replace("${var.origin_url}", "/^(?:\\w+:\\/\\/)?[^/]+(?:\\/(.*)|$)/", "$1")}"
}


# ── outputs.tf ────────────────────────────────────
output "cloudfront_id" {
  description = "The ID of the CloudFront distribution that's used for hosting the content"
  value       = "${aws_cloudfront_distribution.this.id}"
}

output "site_domain" {
  description = "Domain on which the site will be made available"
  value       = "${var.site_domain}"
}


# ── certificate.tf ────────────────────────────────────
# Generate a certificate for the domain automatically using ACM
# https://www.terraform.io/docs/providers/aws/r/acm_certificate.html
resource "aws_acm_certificate" "this" {
  provider          = "aws.us_east_1"                                                              # because ACM is only available in the "us-east-1" region
  domain_name       = "${var.site_domain}"
  validation_method = "DNS"                                                                        # the required records are created below
  tags              = "${merge(var.tags, map("Name", "${var.comment_prefix}${var.site_domain}"))}"
}

# Add the DNS records needed by the ACM validation process
resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.this.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.this.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  records = ["${aws_acm_certificate.this.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

# Request a validation for the cert with ACM
resource "aws_acm_certificate_validation" "this" {
  provider                = "aws.us_east_1"                                # because ACM is only available in the "us-east-1" region
  certificate_arn         = "${aws_acm_certificate.this.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}


# ── cloudfront.tf ────────────────────────────────────
# Create the CloudFront distribution through which the site contents will be served
# https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "${var.default_root_object}"
  aliases             = ["${var.site_domain}"]
  price_class         = "PriceClass_${var.cloudfront_price_class}"
  comment             = "${var.comment_prefix}${var.site_domain}"
  tags                = "${var.tags}"

  # Define the "upstream" for the CloudFront distribution
  origin {
    domain_name = "${local.url_hostname}"
    origin_id   = "default"
    origin_path = "${local.url_path == "" ? "" : "/${local.url_path}"}"

    custom_origin_config {
      http_port              = "${var.origin_custom_port > 0 ? "${var.origin_custom_port}" : 80}"
      https_port             = "${var.origin_custom_port > 0 ? "${var.origin_custom_port}" : 443}"
      origin_protocol_policy = "${local.url_protocol}-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    custom_header {
      name  = "${var.origin_custom_header_name}"
      value = "${var.origin_custom_header_value}"
    }
  }

  # Define how to serve the content to clients
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "default"
    viewer_protocol_policy = "${var.viewer_https_only ? "redirect-to-https" : "allow-all"}"
    compress               = true

    min_ttl     = "${var.cache_ttl_override >= 0 ? var.cache_ttl_override : 0}"     # for reference: AWS default is 0
    default_ttl = "${var.cache_ttl_override >= 0 ? var.cache_ttl_override : 0}"     # for reference: AWS default is 86400 (i.e. one day)
    max_ttl     = "${var.cache_ttl_override >= 0 ? var.cache_ttl_override : 86400}" # i.e. 1 day; for reference: AWS default is 31536000 (i.e. one year)

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    # Note: This will make the Lambda undeletable, as long as this distribution/association exists
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-delete-replicas.html
    lambda_function_association {
      event_type = "viewer-request"                                                                          # one of [ viewer-request, origin-request, viewer-response, origin-response ]
      lambda_arn = "${aws_lambda_function.viewer_request.arn}:${aws_lambda_function.viewer_request.version}"
    }

    # Note: This will make the Lambda undeletable, as long as this distribution/association exists
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/lambda-edge-delete-replicas.html
    lambda_function_association {
      event_type = "viewer-response"                                                                           # one of [ viewer-request, origin-request, viewer-response, origin-response ]
      lambda_arn = "${aws_lambda_function.viewer_response.arn}:${aws_lambda_function.viewer_response.version}"
    }
  }

  # This (and other custom_error_response's below) are important, because otherwise CloudFront defaults to caching errors for 5 minutes.
  # This means that if you accidentally deploy broken code, your users will be stuck seeing the error regardless of how quickly you roll back.
  # Unless a "cache_ttl_override" is provided, we never cache errors.
  # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/custom-error-pages-expiration.html
  custom_error_response {
    error_code            = 400                  # == "Bad Request"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 403                  # == "Forbidden"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 404                  # == "Not Found"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 405                  # == "Method Not Allowed"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 414                  # == "Request-URI Too Long"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 416                  # == "Requested Range Not Satisfiable"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 500                  # == "Internal Server Error"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 501                  # == "Not Implemented"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 502                  # == "Bad Gateway"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 503                  # == "Service Unavailable"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  custom_error_response {
    error_code            = 504                  # == "Gateway Timeout"
    error_caching_min_ttl = "${local.error_ttl}"
  }

  # This is mandatory in Terraform :shrug:
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Attach our auto-generated ACM certificate to the distribution
  # https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html#viewer-certificate-arguments
  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate_validation.this.certificate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}


# ── data.tf ────────────────────────────────────
data "aws_route53_zone" "this" {
  name = "${replace("${var.site_domain}", "/.*\\b(\\w+\\.\\w+)\\.?$/", "$1")}" # e.g. "foo.example.com" => "example.com"
}


# ── lambda.tf ────────────────────────────────────
locals {
  config = {
    basic_auth_username                  = "${var.basic_auth_username}"
    basic_auth_password                  = "${var.basic_auth_password}"
    basic_auth_realm                     = "${var.basic_auth_realm}"
    basic_auth_body                      = "${var.basic_auth_body}"
    override_response_status             = "${var.override_response_status}"
    override_response_status_description = "${var.override_response_status_description}"
    override_response_body               = "${var.override_response_body}"
  }
}

# Lambda@Edge functions don't support environment variables, so let's inline the relevant parts of the config to the JS file.
# (see: "error creating CloudFront Distribution: InvalidLambdaFunctionAssociation: The function cannot have environment variables")
data "template_file" "lambda" {
  template = "${file("${path.module}/lambda.tpl.js")}"

  vars = {
    config               = "${jsonencode(local.config)}"             # single quotes need to be escaped, lest we end up with a parse error on the JS side
    add_response_headers = "${jsonencode(var.add_response_headers)}" # ^ ditto
  }
}

# Lambda functions can only be uploaded as ZIP files, so we need to package our JS file into one
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"

  source {
    filename = "lambda.js"
    content  = "${data.template_file.lambda.rendered}"
  }
}

resource "aws_lambda_function" "viewer_request" {
  provider = "aws.us_east_1" # because: error creating CloudFront Distribution: InvalidLambdaFunctionAssociation: The function must be in region 'us-east-1'

  # lambda_zip.output_path will be absolute, i.e. different on different machines.
  # This can cause Terraform to notice differences that aren't actually there, so let's convert it to a relative one.
  # https://github.com/hashicorp/terraform/issues/7613#issuecomment-332238441
  filename = "${substr(data.archive_file.lambda_zip.output_path, length(path.cwd) + 1, -1)}"

  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "${local.prefix_with_domain}---viewer_request"
  role             = "${aws_iam_role.this.arn}"
  description      = "${var.comment_prefix}${var.site_domain} (request handler)"
  handler          = "lambda.viewer_request"
  runtime          = "nodejs8.10"
  publish          = true                                                        # because: error creating CloudFront Distribution: InvalidLambdaFunctionAssociation: The function ARN must reference a specific function version. (The ARN must end with the version number.)
  tags             = "${var.tags}"
}

resource "aws_lambda_function" "viewer_response" {
  provider = "aws.us_east_1" # because: error creating CloudFront Distribution: InvalidLambdaFunctionAssociation: The function must be in region 'us-east-1'

  # lambda_zip.output_path will be absolute, i.e. different on different machines.
  # This can cause Terraform to notice differences that aren't actually there, so let's convert it to a relative one.
  # https://github.com/hashicorp/terraform/issues/7613#issuecomment-332238441
  filename = "${substr(data.archive_file.lambda_zip.output_path, length(path.cwd) + 1, -1)}"

  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "${local.prefix_with_domain}---viewer_response"
  role             = "${aws_iam_role.this.arn}"
  description      = "${var.comment_prefix}${var.site_domain} (response handler)"
  handler          = "lambda.viewer_response"
  runtime          = "nodejs8.10"
  publish          = true                                                         # because: error creating CloudFront Distribution: InvalidLambdaFunctionAssociation: The function ARN must reference a specific function version. (The ARN must end with the version number.)
  tags             = "${var.tags}"
}

# Allow Lambda@Edge to invoke our functions
resource "aws_iam_role" "this" {
  name = "${local.prefix_with_domain}"
  tags = "${var.tags}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Allow writing logs to CloudWatch from our functions
resource "aws_iam_policy" "this" {
  count = "${var.lambda_logging_enabled ? 1 : 0}"
  name  = "${local.prefix_with_domain}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = "${var.lambda_logging_enabled ? 1 : 0}"
  role       = "${aws_iam_role.this.name}"
  policy_arn = "${aws_iam_policy.this.arn}"
}


# ── route53.tf ────────────────────────────────────
# Add an IPv4 DNS record pointing to the CloudFront distribution
resource "aws_route53_record" "ipv4" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "${var.site_domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.this.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.this.hosted_zone_id}"
    evaluate_target_health = false
  }
}

# Add an IPv6 DNS record pointing to the CloudFront distribution
resource "aws_route53_record" "ipv6" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "${var.site_domain}"
  type    = "AAAA"

  alias {
    name                   = "${aws_cloudfront_distribution.this.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.this.hosted_zone_id}"
    evaluate_target_health = false
  }
}
