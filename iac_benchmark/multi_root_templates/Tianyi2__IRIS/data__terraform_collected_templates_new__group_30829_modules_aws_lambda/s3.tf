# define lambda s3 storage

data "archive_file" "lambda_zip"{
    type = "zip"
    source_dir = var.source_dir
    output_path = var.output_path
}

resource "aws_s3_object" "lambda" {
  
  bucket = var.bucket
  key = var.bucket_key
  source = data.archive_file.lambda_zip.output_path

  etag = filemd5(data.archive_file.lambda_zip.output_path)

  depends_on = [
    data.archive_file.lambda_zip
  ]
}
