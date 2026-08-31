#============================================================
# S3：ビルドしたLambda関数zipファイルをデプロイするバケットの設定
#============================================================

# Lambda関数のzipファイルをデプロイするS3バケットの設定
resource "aws_s3_bucket" "lambda_bucket" {
  # バケット名
  bucket = "${var.project_name}-lambda-${local.lower_random_hex}"
  # バケットの中にオブジェクトが入っていてもTerraformに削除を許可するかどうか(true:許可)
  force_destroy = true
  # タグ
  tags = {
    Name = var.project_name
  }
}



#============================================================
# Lambda
#============================================================

# Lambda関数の設定
resource "aws_lambda_function" "lambda" {
  # 関数のZIPファイルをS3にアップロードした後に実行
  depends_on = [null_resource.lambda_build_upload]
  # 関数名
  function_name = var.project_name
  # 実行環境の指定(ex: nodejs, python, go, etc.)
  runtime = var.lambda_runtime
  # ハンドラの指定
  handler = "dist/index.handler"
  # 作成するLambda関数に対して許可するIAMロールの指定
  role = aws_iam_role.lambda_role.arn
  # Lambda関数のコード取得元S3バケットとパス
  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key    = "lambda.zip"
  # Lambda関数のタイムアウト時間
  timeout = var.lambda_timeout
  # 環境変数の指定
  environment {
    variables = {
      ENV_VAL = "Terraform tutorial"
    }
  }
  # 作成するLambdaの説明文
  description = var.project_name
  # タグ
  tags = {
    Name = var.project_name
  }
}

# Lambda関数のローカルビルドコマンドの設定
resource "null_resource" "lambda_build_upload" {
  # ビルド済みの関数zipファイルアップロード先のS3バケットが生成されたら実行
  depends_on = [aws_s3_bucket.lambda_bucket]
  # ソースコードに差分があった場合に実行
  triggers = {
    code_diff = join("", [
      for file in fileset("api/src", "{*.mts}")
      : filebase64("api/src/${file}")
    ])
    package_diff = join("", [
      for file in fileset("api", "{package*.json}")
      : filebase64("api/${file}")
    ])
  }
  # Lambda関数依存パッケージのインストール
  provisioner "local-exec" {
    # 実行するコマンド
    command = "npm install"
    # コマンドを実行するディレクトリ
    working_dir = "api"
  }
  # Lambda関数コードのビルド
  provisioner "local-exec" {
    command     = "npm run build"
    working_dir = "api"
  }
  # Lambda関数のビルド済みコードと依存パッケージをZIP圧縮
  provisioner "local-exec" {
    command     = "zip -r lambda.zip dist node_modules"
    working_dir = "api"
  }
  # S3アップロード
  provisioner "local-exec" {
    command     = "aws s3 cp lambda.zip s3://${aws_s3_bucket.lambda_bucket.bucket}/lambda.zip"
    working_dir = "api"
  }
}

# Lambda関数の更新
resource "null_resource" "lambda_update" {
  # Lambda関数作成後に実行
  depends_on = [null_resource.lambda_build_upload, aws_lambda_function.lambda]
  # ソースコードに差分があった場合にのみ実行
  triggers = {
    code_diff = join("", [
      for file in fileset("api/src", "{*.mts}")
      : filebase64("api/src/${file}")
    ])
    package_diff = join("", [
      for file in fileset("api", "{package*.json}")
      : filebase64("api/${file}")
    ])
  }
  # Lambda関数を更新
  provisioner "local-exec" {
    command     = "aws lambda update-function-code --function-name ${aws_lambda_function.lambda.function_name} --s3-bucket ${aws_s3_bucket.lambda_bucket.bucket} --s3-key lambda.zip --publish --no-cli-pager"
    working_dir = "api"
  }
}

# CloudWatchロググループの設定
resource "aws_cloudwatch_log_group" "lambda" {
  # CloudWatchロググループ名
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  # ログを残す期間(日)の指定
  retention_in_days = var.lambda_cloudwatch_log_retention_in_days
  # タグ
  tags = {
    Name = var.project_name
  }
}

# IAMロールの設定
resource "aws_iam_role" "lambda_role" {
  # IAMロール名
  name = "${var.project_name}-lambda-iam-role"
  # IAMロールにポリシーを紐付け
  managed_policy_arns = [
    aws_iam_policy.lambda_policy.arn
  ]
  # IAMロールの対象となるAWSサービスの指定
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  # 説明
  description = var.project_name
  # タグ
  tags = {
    Name = var.project_name
  }
}

# IAMロールに紐付けるポリシーの設定
resource "aws_iam_policy" "lambda_policy" {
  # ポリシー名
  name = "${var.project_name}-lambda-iam-policy"
  # ポリシー(どのAWSリソースにどのような操作を許可するか)の定義
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        # 許可する操作の指定
        Action = [
          "logs:*",
          "s3:*",
          "s3-object-lambda:*"
        ]
        # 対象となるAWSリソースのARNの指定
        Resource = [
          "*"
        ]
      }
    ]
  })
  # ポリシーの説明文
  description = var.project_name
  # タグ
  tags = {
    Name = var.project_name
  }
}

# Lambda関数のURLリソースの設定
resource "aws_lambda_function_url" "lambda" {
  function_name      = aws_lambda_function.lambda.function_name
  authorization_type = "NONE"
}

# Lambda関数URL
output "lambda_function_url" {
  description = "Lambda関数URL"
  value       = aws_lambda_function_url.lambda.function_url
}
