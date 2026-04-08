resource "aws_cloudfront_cache_policy" "this" {
  name        = var.name
  comment     = var.comment
  default_ttl = var.default_ttl
  max_ttl     = var.max_ttl
  min_ttl     = var.min_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = var.enable_accept_encoding_brotli
    enable_accept_encoding_gzip   = var.enable_accept_encoding_gzip

    cookies_config {
      cookie_behavior = var.cookie_behavior

      dynamic "cookies" {
        for_each = var.cookies != null ? [var.cookies] : []
        content {
          items = cookies.value.items
        }
      }
    }

    headers_config {
      header_behavior = var.header_behavior

      dynamic "headers" {
        for_each = var.headers != null ? [var.headers] : []
        content {
          items = headers.value.items
        }
      }
    }

    query_strings_config {
      query_string_behavior = var.query_string_behavior

      dynamic "query_strings" {
        for_each = var.query_strings != null ? [var.query_strings] : []
        content {
          items = query_strings.value.items
        }
      }
    }
  }
}