#============================================================
# CloudFront
#============================================================

# ディストリビューションの設定
resource "aws_cloudfront_distribution" "main" {
  # ディストリビューションの有効化
  enabled = true
  # デフォルトルートオブジェクトの設定
  default_root_object = "index.html"
  # 価格クラス (PriceClass_All/PriceClass_200/PriceClass_100)
  # https://docs.aws.amazon.com/ja_jp/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html
  price_class = var.cloudfront_price_class
  # オリジングループの作成
  origin_group {
    origin_id = "group"
    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }
    # S3とLambdaへのアクセス振り分け用のオリジンIDを作成
    member {
      origin_id = "S3"
    }
    member {
      origin_id = "Lambda"
    }
  }
  # オリジンの設定(S3)
  origin {
    # オリジンID
    origin_id = "S3"
    # S3サービスのドメイン名
    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name
    # OAC を設定
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }
  # オリジンの設定(Lambda)
  origin {
    # オリジンID
    origin_id = "Lambda"
    # Lambdaサービスのドメイン名
    domain_name = "${aws_lambda_function_url.lambda.url_id}.lambda-url.${var.region}.on.aws"
    # 許可するプロトコル
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  # 証明書管理
  viewer_certificate {
    # CloudFrontのデフォルトの証明書を使用(ACMで発行した証明書に切り替えることも可能)
    cloudfront_default_certificate = true
  }

  # デフォルトキャッシュビヘイビアの設定
  default_cache_behavior {
    # オリジンID
    target_origin_id = "S3"
    # HTTPはHTTPSにリダイレクトする
    viewer_protocol_policy = "redirect-to-https"
    # 許可するHTTPメソッド
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    # キャッシュするHTTPメソッド
    cached_methods = ["GET", "HEAD"]
    # キャッシュポリシー
    cache_policy_id = data.aws_cloudfront_cache_policy.CachingOptimized.id
    # オリジンリクエストポリシー
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.CORS-S3Origin.id
    # レスポンスヘッダーポリシー
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.SimpleCORS.id
  }
  # デフォルトキャッシュビヘイビアの設定
  ordered_cache_behavior {
    # オリジンID
    target_origin_id = "Lambda"
    # リバースプロキシ先のURL
    path_pattern = "/api/*"
    # HTTPはHTTPSにリダイレクトする
    viewer_protocol_policy = "redirect-to-https"
    # 許可するHTTPメソッド
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    # キャッシュするHTTPメソッド
    cached_methods = ["GET", "HEAD"]
    # キャッシュポリシー
    cache_policy_id = aws_cloudfront_cache_policy.CachingDisabledCookieQueryEnabled.id
  }
  # アクセス制限
  restrictions {
    # 国・地域によるアクセス制限
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  # 説明
  comment = var.project_name
  # タグ
  tags = {
    Name = var.project_name
  }
}

# キャッシュポリシー
data "aws_cloudfront_cache_policy" "CachingOptimized" {
  # AWSのマネージドポリシーを指定
  name = "Managed-CachingOptimized"
}
data "aws_cloudfront_cache_policy" "CachingDisabled" {
  # AWSのマネージドポリシーを指定
  name = "Managed-CachingDisabled"
}
# カスタムキャッシュポリシー
resource "aws_cloudfront_cache_policy" "CachingDisabledCookieQueryEnabled" {
  name    = "CachingDisabledCookieQueryEnabled"
  comment = "キャッシュ無効・クッキー有効・クエリ有効"
  # キャッシュTTLの設定(秒)
  default_ttl = 1
  max_ttl     = 1
  min_ttl     = 1
  # 許可するHTTPヘッダー
  parameters_in_cache_key_and_forwarded_to_origin {
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Origin",
          "Access-Control-Request-Method",
          "Access-Control-Request-Headers",
          "Referer"
        ]
      }
    }
    # 許可するCookie
    cookies_config {
      cookie_behavior = "all"
    }
    # 許可するURLクエリ
    query_strings_config {
      query_string_behavior = "all"
    }
    # Gzip/Brotli圧縮されたオブジェクトをCloudFrontがリクエスト／キャッシュできるようにする
    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }
}

# オリジンリクエストポリシー
data "aws_cloudfront_origin_request_policy" "CORS-S3Origin" {
  # AWSのマネージドポリシーを指定
  name = "Managed-CORS-S3Origin"
}

# レスポンスヘッダーポリシー
data "aws_cloudfront_response_headers_policy" "SimpleCORS" {
  # AWSのマネージドポリシーを指定
  name = "Managed-SimpleCORS"
}

# OACの作成
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "cloudfront-origin-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Cloudfront distributionのURL出力
output "cloudfront_distribution_url" {
  description = "CloudFront distribution URL"
  value       = "https://${aws_cloudfront_distribution.main.domain_name}/"
}
