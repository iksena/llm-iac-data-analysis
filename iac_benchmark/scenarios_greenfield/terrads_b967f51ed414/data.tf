data "archive_file"  "lambda_worker" {
  type = "zip"
  source_dir = local.worker_path
  output_path = local.deploy_path
}