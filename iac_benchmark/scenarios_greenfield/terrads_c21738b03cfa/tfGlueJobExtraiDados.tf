resource "aws_glue_job" "etl_jobs" {
  name     = var.glueJobName
  role_arn = aws_iam_role.glue_role_ingestion_resource.arn

  command {
    python_version  = var.python_version
    script_location = "s3://${var.bucket_artefact_glue}-${local.account_id}/glueClima/extraiDados.py"
  }
  default_arguments = {
    "--TempDir"                          = "s3://${var.bucket_log}-${local.account_id}/tempClima"
    "--enable-continuous-cloudwatch-log" = "True"
    "--enable-glue-datacatalog"          = "True"
    "--enable-metrics"                   = "True"
    "--enable-spark-ui"                  = "True"
    "--job-language"                     = "python"
  }
  execution_property {
    max_concurrent_runs = 2
  }
  glue_version      = "4.0"
  max_retries       = 0
  worker_type       = "G.1X"
  number_of_workers = 20
  timeout           = 2880
  tags              = local.common_tags
}