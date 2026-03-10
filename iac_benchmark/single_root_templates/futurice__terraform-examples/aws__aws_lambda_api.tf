# ── main.tf ────────────────────────────────────
# Based on: https://www.terraform.io/docs/providers/aws/guides/serverless-with-aws-lambda-and-api-gateway.html
# See also: https://github.com/hashicorp/terraform/issues/10157
# See also: https://github.com/carrot/terraform-api-gateway-cors-module/

# This aws_lambda_function is used when invoked with a local zipfile
resource "aws_lambda_function" "local_zipfile" {
  count = "${var.function_s3_bucket == "" ? 1 : 0}"

  # These are SPECIFIC to the deployment method:
  filename         = "${var.function_zipfile}"
  source_code_hash = "${var.function_s3_bucket == "" ? "${base64sha256(file("${var.function_zipfile}"))}" : ""}"

  # These are the SAME for both:
  description   = "${var.comment_prefix}${var.api_domain}"
  function_name = "${local.prefix_with_domain}"
  handler       = "${var.function_handler}"
  runtime       = "${var.function_runtime}"
  timeout       = "${var.function_timeout}"
  memory_size   = "${var.memory_size}"
  role          = "${aws_iam_role.this.arn}"
  tags          = "${var.tags}"

  environment {
    variables = "${var.function_env_vars}"
  }
}

# This aws_lambda_function is used when invoked with a zipfile in S3
resource "aws_lambda_function" "s3_zipfile" {
  count = "${var.function_s3_bucket == "" ? 0 : 1}"

  # These are SPECIFIC to the deployment method:
  s3_bucket = "${var.function_s3_bucket}"
  s3_key    = "${var.function_zipfile}"

  # These are the SAME for both:
  description   = "${var.comment_prefix}${var.api_domain}"
  function_name = "${local.prefix_with_domain}"
  handler       = "${var.function_handler}"
  runtime       = "${var.function_runtime}"
  timeout       = "${var.function_timeout}"
  memory_size   = "${var.memory_size}"
  role          = "${aws_iam_role.this.arn}"
  tags          = "${var.tags}"

  environment {
    variables = "${var.function_env_vars}"
  }
}

# Terraform isn't particularly helpful when you want to depend on the existence of a resource which may have count 0 or 1, like our functions.
# This is a hacky way of referring to the properties of the function, regardless of which one got created.
# https://github.com/hashicorp/terraform/issues/16580#issuecomment-342573652
locals {
  function_id         = "${element(concat(aws_lambda_function.local_zipfile.*.id, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.id, list("")), 0)}"
  function_arn        = "${element(concat(aws_lambda_function.local_zipfile.*.arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.arn, list("")), 0)}"
  function_invoke_arn = "${element(concat(aws_lambda_function.local_zipfile.*.invoke_arn, list("")), 0)}${element(concat(aws_lambda_function.s3_zipfile.*.invoke_arn, list("")), 0)}"
}


# ── variables.tf ────────────────────────────────────
variable "api_domain" {
  description = "Domain on which the Lambda will be made available (e.g. `\"api.example.com\"`)"
}

variable "name_prefix" {
  description = "Name prefix to use for objects that need to be created (only lowercase alphanumeric characters and hyphens allowed, for S3 bucket name compatibility)"
  default     = "aws-lambda-api---"
}

variable "comment_prefix" {
  description = "This will be included in comments for resources that are created"
  default     = "Lambda API: "
}

variable "function_zipfile" {
  description = "Path to a ZIP file that will be installed as the Lambda function (e.g. `\"my-api.zip\"`)"
}

variable "function_s3_bucket" {
  description = "When provided, the zipfile is retrieved from an S3 bucket by this name instead (filename is still provided via `function_zipfile`)"
  default     = ""
}

variable "function_handler" {
  description = "Instructs Lambda on which function to invoke within the ZIP file"
  default     = "index.handler"
}

variable "function_timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = 3
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  default     = 128
}

variable "function_runtime" {
  description = "Which node.js version should Lambda use for this function"
  default     = "nodejs8.10"
}

variable "function_env_vars" {
  description = "Which env vars (if any) to invoke the Lambda with"
  type        = "map"

  default = {
    # This effectively useless, but an empty map can't be used in the "aws_lambda_function" resource
    # -> this is 100% safe to override with your own env, should you need one
    aws_lambda_api = ""
  }
}

variable "stage_name" {
  description = "Name of the single stage created for the API on API Gateway" # we're not using the deployment features of API Gateway, so a single static stage is fine
  default     = "default"
}

variable "lambda_logging_enabled" {
  description = "When true, writes any console output to the Lambda function's CloudWatch group"
  default     = false
}

variable "api_gateway_logging_level" {
  description = "Either `\"OFF\"`, `\"INFO\"` or `\"ERROR\"`; note that this requires having a CloudWatch log role ARN globally in API Gateway Settings"
  default     = "OFF"
}

variable "api_gateway_cloudwatch_metrics" {
  description = "When true, sends metrics to CloudWatch"
  default     = false
}

variable "tags" {
  description = "AWS Tags to add to all resources created (where possible); see https://aws.amazon.com/answers/account-management/aws-tagging-strategies/"
  type        = "map"
  default     = {}
}

variable "throttling_rate_limit" {
  description = "How many sustained requests per second should the API process at most; see https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html"
  default     = 10000
}

variable "throttling_burst_limit" {
  description = "How many burst requests should the API process at most; see https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-request-throttling.html"
  default     = 5000
}

locals {
  prefix_with_domain = "${var.name_prefix}${replace("${var.api_domain}", "/[^a-z0-9-]+/", "-")}" # only lowercase alphanumeric characters and hyphens are allowed in e.g. S3 bucket names
}


# ── outputs.tf ────────────────────────────────────
output "function_name" {
  description = "This is the unique name of the Lambda function that was created"
  value       = "${local.function_id}"
}

output "api_gw_invoke_url" {
  description = "This URL can be used to invoke the Lambda through the API Gateway"
  value       = "${aws_api_gateway_deployment.this.invoke_url}"
}


# ── api_gateway_config.tf ────────────────────────────────────
resource "aws_api_gateway_rest_api" "this" {
  name        = "${local.prefix_with_domain}"
  description = "${var.comment_prefix}${var.api_domain}"
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = "${aws_api_gateway_rest_api.this.id}"

  depends_on = [
    "aws_api_gateway_integration.proxy_root",
    "aws_api_gateway_integration.proxy_other",
  ]
}

resource "aws_api_gateway_stage" "this" {
  stage_name    = "${var.stage_name}"
  description   = "${var.comment_prefix}${var.api_domain}"
  rest_api_id   = "${aws_api_gateway_rest_api.this.id}"
  deployment_id = "${aws_api_gateway_deployment.this.id}"
  tags          = "${var.tags}"
}

resource "aws_api_gateway_method_settings" "this" {
  rest_api_id = "${aws_api_gateway_rest_api.this.id}"
  stage_name  = "${aws_api_gateway_stage.this.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled        = "${var.api_gateway_cloudwatch_metrics}"
    logging_level          = "${var.api_gateway_logging_level}"
    data_trace_enabled     = "${var.api_gateway_logging_level == "OFF" ? false : true}"
    throttling_rate_limit  = "${var.throttling_rate_limit}"
    throttling_burst_limit = "${var.throttling_burst_limit}"
  }
}

resource "aws_api_gateway_domain_name" "this" {
  domain_name              = "${var.api_domain}"
  regional_certificate_arn = "${aws_acm_certificate_validation.this.certificate_arn}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = "${aws_api_gateway_rest_api.this.id}"
  stage_name  = "${aws_api_gateway_stage.this.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.this.domain_name}"
}


# ── api_gateway_resources.tf ────────────────────────────────────
# Add root resource to the API (it it needs to be included separately from the "proxy" resource defined below), which forwards to our Lambda:

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.this.id}"
  resource_id   = "${aws_api_gateway_rest_api.this.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_root" {
  rest_api_id             = "${aws_api_gateway_rest_api.this.id}"
  resource_id             = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method             = "${aws_api_gateway_method.proxy_root.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${local.function_invoke_arn}"
}

# Add a "proxy" resource, that matches all paths (except the root, defined above) and forwards them to our Lambda:

resource "aws_api_gateway_resource" "proxy_other" {
  rest_api_id = "${aws_api_gateway_rest_api.this.id}"
  parent_id   = "${aws_api_gateway_rest_api.this.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_other" {
  rest_api_id   = "${aws_api_gateway_rest_api.this.id}"
  resource_id   = "${aws_api_gateway_resource.proxy_other.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_other" {
  rest_api_id             = "${aws_api_gateway_rest_api.this.id}"
  resource_id             = "${aws_api_gateway_method.proxy_other.resource_id}"
  http_method             = "${aws_api_gateway_method.proxy_other.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${local.function_invoke_arn}"
}

resource "aws_api_gateway_method_response" "proxy_other" {
  rest_api_id = "${aws_api_gateway_rest_api.this.id}"
  resource_id = "${aws_api_gateway_resource.proxy_other.id}"
  http_method = "${aws_api_gateway_method.proxy_other.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "proxy_other" {
  depends_on  = ["aws_api_gateway_integration.proxy_other"]
  rest_api_id = "${aws_api_gateway_rest_api.this.id}"
  resource_id = "${aws_api_gateway_resource.proxy_other.id}"
  http_method = "${aws_api_gateway_method.proxy_other.http_method}"
  status_code = "${aws_api_gateway_method_response.proxy_other.status_code}"

  response_templates = {
    "application/json" = ""
  }
}


# ── certificate.tf ────────────────────────────────────
# Generate a certificate for the domain automatically using ACM
# https://www.terraform.io/docs/providers/aws/r/acm_certificate.html
resource "aws_acm_certificate" "this" {
  domain_name       = "${var.api_domain}"
  validation_method = "DNS"                                                                       # the required records are created below
  tags              = "${merge(var.tags, map("Name", "${var.comment_prefix}${var.api_domain}"))}"
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
  certificate_arn         = "${aws_acm_certificate.this.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}


# ── data.tf ────────────────────────────────────
data "aws_route53_zone" "this" {
  name = "${replace("${var.api_domain}", "/.*\\b(\\w+\\.\\w+)\\.?$/", "$1")}" # e.g. "foo.example.com" => "example.com"
}


# ── permissions.tf ────────────────────────────────────
# Allow Lambda to invoke our functions:
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

# Allow API Gateway to invoke our functions:
resource "aws_lambda_permission" "this" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${local.function_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_stage.this.execution_arn}/*/*" # the /*/* portion grants access from any method on any resource within the API Gateway "REST API"
}

# Allow writing logs to CloudWatch from our functions:
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
# Add an IPv4 DNS record pointing to the API Gateway
resource "aws_route53_record" "ipv4" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "${var.api_domain}"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.this.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.this.regional_zone_id}"
    evaluate_target_health = false
  }
}

# Add an IPv6 DNS record pointing to the API Gateway
resource "aws_route53_record" "ipv6" {
  zone_id = "${data.aws_route53_zone.this.zone_id}"
  name    = "${var.api_domain}"
  type    = "AAAA"

  alias {
    name                   = "${aws_api_gateway_domain_name.this.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.this.regional_zone_id}"
    evaluate_target_health = false
  }
}
