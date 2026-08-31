#============================================================
# S3
#============================================================

# バケット名とタグの設定
resource "aws_s3_bucket" "frontend" {
  # バケット名
  bucket = "${var.project_name}-${local.lower_random_hex}"
  # バケットにオブジェクトが入っていて削除を許可するかどうか(true:許可)
  force_destroy = true
  # タグ
  tags = {
    Name = var.project_name
  }
}

# パブリックアクセスのブロック設定
resource "aws_s3_bucket_public_access_block" "frontend" {
  # パブリックアクセスブロックを設定するバケット名
  bucket = aws_s3_bucket.frontend.id
  # パブリックアクセスのブロック
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 他のAWSアカウントによるバケットアクセスコントロールの設定
resource "aws_s3_account_public_access_block" "frontend" {
  block_public_acls   = false
  block_public_policy = false
}

# バケットポリシー
resource "aws_s3_bucket_policy" "frontend" {
  # バケットポリシーを設定するバケットのID
  bucket = aws_s3_bucket.frontend.id
  # CloudFront Distributionからのアクセスのみ許可するポリシーを追加
  policy = data.aws_iam_policy_document.frontend_policy.json
}
# CloudFront Distributionからのアクセスのみ許可するポリシー
data "aws_iam_policy_document" "frontend_policy" {
  statement {
    sid    = "0"
    effect = "Allow"
    # アクセス元の設定
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    # バケットに対して制御するアクションの設定
    actions = ["s3:GetObject"]
    # アクセス先の設定
    resources = ["${aws_s3_bucket.frontend.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.main.arn]
    }
  }
}

# CORSの設定
resource "aws_s3_bucket_cors_configuration" "frontend" {
  # CORを設定するバケットのID
  bucket = aws_s3_bucket.frontend.id
  # CORSルール
  cors_rule {
    allowed_headers = ["*"]   # 許可するリクエストヘッダー
    allowed_methods = ["GET"] # オリジン間リクエストで許可するHTTPメソッド
    allowed_origins = ["*"]   # オリジン間アクセスを許可するアクセス元
    expose_headers  = []      # ブラウザからアクセスを許可するレスポンスヘッダー
  }
}

# オブジェクトのバージョン管理の設定
resource "aws_s3_bucket_versioning" "frontend" {
  # バージョン管理を設定するバケットのID
  bucket = aws_s3_bucket.frontend.id
  # バケットのバージョン管理の設定（Enabled/Disabled）
  versioning_configuration {
    status = "Enabled"
  }
}

# Webページのアップロード
locals {
  src_dir = "./frontend"                            # アップロード対象のディレクトリ
  dst_dir = "s3://${aws_s3_bucket.frontend.bucket}" # アップロード先
}
resource "null_resource" "fileupload" {
  # S3バケットの作成後に実行
  depends_on = [aws_s3_bucket.frontend]
  # React WebアプリをS3バケットにアップロード
  provisioner "local-exec" {
    command = "aws s3 cp ${local.src_dir} ${local.dst_dir} --recursive"
  }
}
