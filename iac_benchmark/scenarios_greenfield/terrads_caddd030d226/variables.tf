#============================================================
# 環境変数の定義（terraform.tfvarsの変数値を受け取る）
#============================================================
# プロジェクト名
variable "project_name" { default = "benchmark" }
#============================================================
# AWS Account
#============================================================
# AWSのリージョン
variable "region" { default = "us-east-1" }
# AWSアクセスキーのプロファイル
variable "profile" { default = "unused" }
#============================================================
# CloudFront
#============================================================
# 価格クラス (PriceClass_All/PriceClass_200/PriceClass_100)
# https://docs.aws.amazon.com/ja_jp/AmazonCloudFront/latest/DeveloperGuide/PriceClass.html
variable "cloudfront_price_class" { default = "PriceClass_100" }
#============================================================
# Lambda
#============================================================
# 実行ランタイム（ex: nodejs, python, go, etc.）
variable "lambda_runtime" { default = "python3.12" }
# Lambda関数のタイムアウト時間
variable "lambda_timeout" { default = 30 }
# CloudWatchにログを残す期間（日）
variable "lambda_cloudwatch_log_retention_in_days" { default = 14 }
#============================================================
# API Gateway
#============================================================
# API URLステージ名
variable "apigateway_stage_name" { default = "prod" }
