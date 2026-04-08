resource "aws_glue_catalog_database" "my_database" {
  name = var.glue_database_name
}

resource "aws_glue_crawler" "my_crawler" {
  name = var.glue_crawler_name
  database_name = aws_glue_catalog_database.my_database.name
  role = var.glue_role_arn
  s3_target {
    path = "s3://${var.bucket_name}/offers/"
  }
}

resource "aws_glue_trigger" "crawler_trigger" {
  name     = "${var.glue_crawler_name}-trigger"
  schedule = var.crawler_schedule_expression
  type     = "SCHEDULED"

  actions {
    crawler_name = aws_glue_crawler.my_crawler.name
  }
}
