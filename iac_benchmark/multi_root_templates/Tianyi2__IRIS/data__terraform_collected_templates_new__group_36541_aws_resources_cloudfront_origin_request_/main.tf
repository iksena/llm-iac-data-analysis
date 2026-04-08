resource "aws_cloudfront_origin_request_policy" "this" {
  name    = var.name
  comment = var.comment

  cookies_config {
    cookie_behavior = var.cookies_config.cookie_behavior

    dynamic "cookies" {
      for_each = var.cookies_config.cookies != null ? [var.cookies_config.cookies] : []
      content {
        items = cookies.value.items
      }
    }
  }

  headers_config {
    header_behavior = var.headers_config.header_behavior

    dynamic "headers" {
      for_each = var.headers_config.headers != null ? [var.headers_config.headers] : []
      content {
        items = headers.value.items
      }
    }
  }

  query_strings_config {
    query_string_behavior = var.query_strings_config.query_string_behavior

    dynamic "query_strings" {
      for_each = var.query_strings_config.query_strings != null ? [var.query_strings_config.query_strings] : []
      content {
        items = query_strings.value.items
      }
    }
  }
}