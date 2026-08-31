#-------------------------------------------------------------------------------------
# Bucket Artefatos Jobs Glue
#-------------------------------------------------------------------------------------
resource "aws_s3_bucket" "artefact_glue" {
  bucket = "${var.bucket_artefact_glue}-${local.account_id}"
}

resource "aws_s3_bucket_versioning" "artefact_glue_versioning" {
  bucket = aws_s3_bucket.artefact_glue.id
  versioning_configuration {
    status = "Enabled"
  }
}

#-------------------------------------------------------------------------------------
# Buckets Data Lake
#-------------------------------------------------------------------------------------
resource "aws_s3_bucket" "lake_staging" {
  bucket = "${var.bucket_staging_lake}-${local.account_id}"
}

resource "aws_s3_bucket" "lake_bronze" {
  bucket = "${var.bucket_bronze_lake}-${local.account_id}"
}
resource "aws_s3_bucket_versioning" "lake_versioning_bronze" {
  bucket = aws_s3_bucket.lake_bronze.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "lake_silver" {
  bucket = "${var.bucket_silver_lake}-${local.account_id}"
}
resource "aws_s3_bucket_versioning" "lake_versioning_silver" {
  bucket = aws_s3_bucket.lake_silver.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket" "lake_gold" {
  bucket = "${var.bucket_gold_lake}-${local.account_id}"
}
resource "aws_s3_bucket_versioning" "lake_versioning_gold" {
  bucket = aws_s3_bucket.lake_gold.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket" "logdir" {
  bucket = "${var.bucket_log}-${local.account_id}"
}


## Copia Script Glue para o Bucket artefact_glue
resource "aws_s3_object" "artefact_glue" {
  depends_on = [aws_s3_bucket_versioning.artefact_glue_versioning]
  for_each   = fileset("glueClima/", "**")
  bucket     = aws_s3_bucket.artefact_glue.id
  key        = "glueClima/${each.value}"
  source     = "glueClima/${each.value}"
  etag       = filemd5("glueClima/${each.value}")
}
