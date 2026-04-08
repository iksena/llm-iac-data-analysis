resource "aws_cur_report_definition" "this" {
  report_name                = var.report_name
  time_unit                  = var.time_unit
  format                     = var.format
  compression                = var.compression
  additional_schema_elements = var.additional_schema_elements
  s3_bucket                  = var.s3_bucket
  s3_prefix                  = var.s3_prefix
  s3_region                  = var.s3_region
  additional_artifacts       = var.additional_artifacts
  refresh_closed_reports     = var.refresh_closed_reports
  report_versioning          = var.report_versioning
  tags                       = var.tags

  lifecycle {
    precondition {
      condition     = !(var.format == "Parquet" && var.compression != "Parquet")
      error_message = "If format is Parquet, then compression must also be Parquet."
    }

    precondition {
      condition     = !(var.compression == "Parquet" && var.format != "Parquet")
      error_message = "If compression is Parquet, then format must also be Parquet."
    }

    precondition {
      condition     = !(contains(var.additional_artifacts, "ATHENA") && var.report_versioning != "OVERWRITE_REPORT")
      error_message = "When ATHENA exists within additional_artifacts, report_versioning must be OVERWRITE_REPORT."
    }
  }
}